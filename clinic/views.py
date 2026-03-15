from django.shortcuts import render, redirect, get_object_or_404
from django.db import transaction
from django.db.models import Q
from django.contrib import messages
from datetime import datetime

from .models import Patient, Product, Treatment, SalesTransaction, TransactionItem, PatientVisit, ClinicBranch, Supplier, InventoryShipment, ReceivedProduct, BranchProduct


# ─────────────────────────────────────────────
# CHARGESLIP (Create New Sale)
# ─────────────────────────────────────────────
def chargeslip(request):
    if request.method == 'POST':
        errors = []

        is_new_patient = request.POST.get('is_new_patient') == 'true'
        notes = request.POST.get('notes', '').strip()

        if is_new_patient:
            required_new = {
                'last_name': 'Last Name',
                'first_name': 'First Name',
                'birthday': 'Birthday',
                'sex': 'Sex',
                'address': 'Address',
                'contact': 'Contact Number',
            }
            for field, label in required_new.items():
                if not request.POST.get(field, '').strip():
                    errors.append(f'{label} is required for new patients.')
        else:
            patient_id = request.POST.get('patient', '').strip()
            if not patient_id:
                errors.append('Please select an existing patient or register a new one.')

        if not request.POST.get('mode_of_payment', '').strip():
            errors.append('Please select a mode of payment.')

        product_ids = [p for p in request.POST.getlist('actual_product_ids') if p]
        treatment_ids = [t for t in request.POST.getlist('actual_treatment_ids') if t]
        if not product_ids and not treatment_ids:
            errors.append('Please add at least one product or treatment.')

        for qty in request.POST.getlist('product_qtys'):
            try:
                if int(qty) < 1:
                    errors.append('Product quantities must be at least 1.')
                    break
            except (ValueError, TypeError):
                errors.append('Invalid product quantity entered.')
                break

        for qty in request.POST.getlist('treatment_qtys'):
            try:
                if int(qty) < 1:
                    errors.append('Treatment quantities must be at least 1.')
                    break
            except (ValueError, TypeError):
                errors.append('Invalid treatment quantity entered.')
                break

        if errors:
            for error in errors:
                messages.error(request, error)
            patients = Patient.objects.all().order_by('last_name')
            products = Product.objects.all().order_by('product_name')
            treatments = Treatment.objects.all().order_by('treatment_name')
            return render(request, 'clinic/chargeslip.html', {
                'patients': patients,
                'products': products,
                'treatments': treatments,
            })

        try:
            with transaction.atomic():
                if is_new_patient:
                    last = request.POST.get('last_name').strip()
                    first = request.POST.get('first_name').strip()
                    bday = request.POST.get('birthday').strip()
                    if Patient.objects.filter(last_name__iexact=last, first_name__iexact=first, birthday=bday).exists():
                        messages.error(request, f'A patient named {first} {last} with the same birthday already exists.')
                        return redirect('chargeslip')

                    patient = Patient.objects.create(
                        last_name=last,
                        first_name=first,
                        middle_name=request.POST.get('middle_name', '').strip(),
                        suffix=request.POST.get('suffix', '').strip() or "",
                        patient_contact_number=request.POST.get('contact', '').strip(),
                        patient_address=request.POST.get('address', '').strip(),
                        birthday=bday,
                        sex=request.POST.get('sex'),
                    )
                else:
                    patient = Patient.objects.get(pk=request.POST.get('patient'))

                grand_total = float(request.POST.get('grandTotal', 0) or 0)
                total_products = 0
                total_treatments = 0

                product_ids_list = request.POST.getlist('actual_product_ids')
                product_qtys = request.POST.getlist('product_qtys')
                treatment_ids_list = request.POST.getlist('actual_treatment_ids')
                treatment_qtys = request.POST.getlist('treatment_qtys')

                for pid, qty in zip(product_ids_list, product_qtys):
                    if pid:
                        product = Product.objects.get(pk=pid)
                        qty = int(qty)
                        total_products += float(product.unit_cost) * qty

                for tid, qty in zip(treatment_ids_list, treatment_qtys):
                    if tid:
                        treatment = Treatment.objects.get(pk=tid)
                        qty = int(qty)
                        total_treatments += float(treatment.treatment_cost) * qty

                sale = SalesTransaction.objects.create(
                    patient=patient,
                    total_price_of_products=total_products,
                    total_price_of_treatments=total_treatments,
                    total_amount=total_products + total_treatments,
                    mode_of_payment=request.POST.get('mode_of_payment'),
                    notes=notes
                )

                for pid, qty in zip(product_ids_list, product_qtys):
                    if pid:
                        product = Product.objects.get(pk=pid)
                        qty = int(qty)
                        TransactionItem.objects.create(
                            transaction=sale,
                            product=product,
                            quantity_purchased=qty,
                            subtotal=product.unit_cost * qty,
                        )
                        # ── Deduct stock from BranchProduct ──
                        branch_product = BranchProduct.objects.filter(product=product).first()
                        if branch_product:
                            branch_product.stock_quantity = max(0, branch_product.stock_quantity - qty)
                            branch_product.save()

                for tid, qty in zip(treatment_ids_list, treatment_qtys):
                    if tid:
                        treatment = Treatment.objects.get(pk=tid)
                        qty = int(qty)
                        TransactionItem.objects.create(
                            transaction=sale,
                            treatment=treatment,
                            quantity_purchased=qty,
                            subtotal=treatment.treatment_cost * qty,
                        )

            messages.success(request, 'Charge slip saved successfully.')
            return redirect('patient_db')

        except Exception as e:
            messages.error(request, f'An error occurred while saving: {str(e)}')

    patients = Patient.objects.all().order_by('last_name')
    products = Product.objects.all().order_by('product_type', 'product_name')
    treatments = Treatment.objects.all().order_by('treatment_type', 'treatment_name')
    return render(request, 'clinic/chargeslip.html', {
        'patients': patients,
        'products': products,
        'treatments': treatments,
    })


# ─────────────────────────────────────────────
# PATIENT DATABASE
# ─────────────────────────────────────────────
def patient_db(request):
    query = request.GET.get("q", "").strip()
    patients = Patient.objects.all()
    if query:
        patients = patients.filter(
            Q(last_name__icontains=query) |
            Q(first_name__icontains=query) |
            Q(middle_name__icontains=query) |
            Q(suffix__icontains=query)
        )
    patients = patients.order_by("last_name", "first_name")
    return render(request, "clinic/patient_db.html", {
        "patients": patients,
        "query": query,
    })


# ─────────────────────────────────────────────
# PATIENT DETAILS
# ─────────────────────────────────────────────
def patient_details(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)
    transactions = SalesTransaction.objects.filter(patient=patient).order_by('-transaction_date')
    return render(request, 'clinic/patient_details.html', {
        'patient': patient,
        'transactions': transactions,
    })


# ─────────────────────────────────────────────
# PATIENT ADD
# ─────────────────────────────────────────────
def patient_add(request):
    if request.method == 'POST':
        errors = []

        last = request.POST.get('last_name', '').strip()
        first = request.POST.get('first_name', '').strip()
        address = request.POST.get('patient_address', '').strip()
        contact = request.POST.get('patient_contact_number', '').strip()
        birthday = request.POST.get('birthday', '').strip()
        sex = request.POST.get('sex', '').strip()

        if not last:
            errors.append('Last Name is required.')
        if not first:
            errors.append('First Name is required.')
        if not address:
            errors.append('Address is required.')
        if not contact:
            errors.append('Contact Number is required.')
        if not birthday:
            errors.append('Birthday is required.')
        if not sex:
            errors.append('Sex is required.')

        if not errors:
            if Patient.objects.filter(last_name__iexact=last, first_name__iexact=first, birthday=birthday).exists():
                errors.append(f'A patient named {first} {last} with the same birthday already exists.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return render(request, 'clinic/patient_add.html', {'form_data': request.POST})

        Patient.objects.create(
            last_name=last,
            first_name=first,
            middle_name=request.POST.get('middle_name', '').strip(),
            suffix=request.POST.get('suffix', '').strip() or "",
            patient_address=address,
            patient_contact_number=contact,
            birthday=birthday,
            sex=sex,
        )
        messages.success(request, f'Patient {first} {last} added successfully.')
        return redirect('patient_db')

    return render(request, 'clinic/patient_add.html', {'form_data': {}})


# ─────────────────────────────────────────────
# PATIENT UPDATE
# ─────────────────────────────────────────────
def patient_update(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)

    if request.method == 'POST':
        errors = []

        last = request.POST.get('last_name', '').strip()
        first = request.POST.get('first_name', '').strip()
        address = request.POST.get('patient_address', '').strip()
        contact = request.POST.get('patient_contact_number', '').strip()
        birthday = request.POST.get('birthday', '').strip()
        sex = request.POST.get('sex', '').strip()

        if not last:
            errors.append('Last Name is required.')
        if not first:
            errors.append('First Name is required.')
        if not address:
            errors.append('Address is required.')
        if not contact:
            errors.append('Contact Number is required.')
        if not birthday:
            errors.append('Birthday is required.')
        if not sex:
            errors.append('Sex is required.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return render(request, 'clinic/patient_update.html', {'patient': patient})

        patient.last_name = last
        patient.first_name = first
        patient.middle_name = request.POST.get('middle_name', '').strip()
        patient.suffix = request.POST.get('suffix', '').strip() or ""
        patient.patient_address = address
        patient.patient_contact_number = contact
        patient.birthday = birthday
        patient.sex = sex
        patient.save()

        messages.success(request, f'Patient {first} {last} updated successfully.')
        return redirect('patient_db')

    return render(request, 'clinic/patient_update.html', {'patient': patient})


# ─────────────────────────────────────────────
# PATIENT DELETE
# ─────────────────────────────────────────────
def patient_delete(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)
    if request.method == 'POST':
        name = f'{patient.first_name} {patient.last_name}'
        patient.delete()
        messages.success(request, f'Patient {name} has been deleted.')
        return redirect('patient_db')
    return redirect('patient_update', patient_id=patient_id)


# ─────────────────────────────────────────────
# SALES DATABASE
# ─────────────────────────────────────────────
def sales_db(request):
    query = request.GET.get("q", "").strip()
    date_filter = request.GET.get("date", "").strip()

    sales = SalesTransaction.objects.all().select_related("patient")

    if query:
        sales = sales.filter(
            Q(patient__last_name__icontains=query) |
            Q(patient__first_name__icontains=query) |
            Q(patient__middle_name__icontains=query) |
            Q(patient__suffix__icontains=query)
        )

    if date_filter:
        try:
            if " to " in date_filter:
                start_str, end_str = date_filter.split(" to ")
                start_date = datetime.strptime(start_str.strip(), "%Y-%m-%d").date()
                end_date = datetime.strptime(end_str.strip(), "%Y-%m-%d").date()
                sales = sales.filter(transaction_date__range=[start_date, end_date])
            else:
                single_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
                sales = sales.filter(transaction_date=single_date)
        except ValueError:
            pass

    sales = sales.order_by("-transaction_date")

    return render(request, "clinic/sales_db.html", {
        "sales": sales,
        "query": query,
        "date_filter": date_filter,
    })


# ─────────────────────────────────────────────
# VIEW CHARGESLIP
# ─────────────────────────────────────────────
def _get_chargeslip_context(transaction_id):
    sale = get_object_or_404(
        SalesTransaction.objects.select_related('patient'),
        transaction_id=transaction_id,
    )

    items = TransactionItem.objects.filter(
        transaction=sale
    ).select_related('product', 'treatment')

    products = [i for i in items if i.product]
    treatments = [i for i in items if i.treatment]

    product_total = sum(i.subtotal for i in products)
    treatment_total = sum(i.subtotal for i in treatments)

    notes = sale.notes

    return {
        'transaction': sale,
        'patient': sale.patient,
        'products': products,
        'treatments': treatments,
        'product_total': product_total,
        'treatment_total': treatment_total,
        'notes': notes,
    }

def view_chargeslip_patient(request, transaction_id):
    context = _get_chargeslip_context(transaction_id)
    return render(request, 'clinic/chargeslip_view.html', context)

def view_chargeslip_sales(request, transaction_id):
    context = _get_chargeslip_context(transaction_id)
    return render(request, 'clinic/chargeslip_view_sales.html', context)


# ─────────────────────────────────────────────
# SALES UPDATE
# ─────────────────────────────────────────────
def sales_update(request, transaction_id):
    sale = get_object_or_404(SalesTransaction, transaction_id=transaction_id)

    if request.method == 'POST':
        errors = []

        transaction_date = request.POST.get('transaction_date', '').strip()
        mode_of_payment = request.POST.get('mode_of_payment', '').strip()
        product_ids = [p for p in request.POST.getlist('product_ids') if p]
        treatment_ids = [t for t in request.POST.getlist('treatment_ids') if t]

        if not transaction_date:
            errors.append('Transaction date is required.')
        if not mode_of_payment:
            errors.append('Mode of payment is required.')
        if not product_ids and not treatment_ids:
            errors.append('Please add at least one product or treatment.')

        if errors:
            for error in errors:
                messages.error(request, error)
            items = TransactionItem.objects.filter(transaction=sale)
            return render(request, 'clinic/sales_update.html', {
                'sale': sale,
                'products': [i for i in items if i.product],
                'treatments': [i for i in items if i.treatment],
                'all_products': Product.objects.all(),
                'all_treatments': Treatment.objects.all(),
            })

        try:
            with transaction.atomic():
                sale.transaction_date = transaction_date
                sale.mode_of_payment = mode_of_payment
                sale.save()

                TransactionItem.objects.filter(transaction=sale).delete()

                total_products = 0
                total_treatments = 0

                product_qtys = request.POST.getlist('product_qtys')
                for pid, qty in zip(product_ids, product_qtys):
                    if pid and qty:
                        product = Product.objects.get(pk=pid)
                        qty = int(qty)
                        subtotal = product.unit_cost * qty
                        TransactionItem.objects.create(
                            transaction=sale,
                            product=product,
                            quantity_purchased=qty,
                            subtotal=subtotal,
                        )
                        total_products += float(subtotal)

                treatment_qtys = request.POST.getlist('treatment_qtys')
                for tid, qty in zip(treatment_ids, treatment_qtys):
                    if tid and qty:
                        treatment = Treatment.objects.get(pk=tid)
                        qty = int(qty)
                        subtotal = treatment.treatment_cost * qty
                        TransactionItem.objects.create(
                            transaction=sale,
                            treatment=treatment,
                            quantity_purchased=qty,
                            subtotal=subtotal,
                        )
                        total_treatments += float(subtotal)

                sale.total_price_of_products = total_products
                sale.total_price_of_treatments = total_treatments
                sale.total_amount = total_products + total_treatments
                sale.save()

            messages.success(request, f'Sale #{sale.transaction_id} updated successfully.')
            return redirect('sales_db')

        except Exception as e:
            messages.error(request, f'An error occurred while saving: {str(e)}')

    items = TransactionItem.objects.filter(transaction=sale)
    return render(request, 'clinic/sales_update.html', {
        'sale': sale,
        'products': [i for i in items if i.product],
        'treatments': [i for i in items if i.treatment],
        'all_products': Product.objects.all(),
        'all_treatments': Treatment.objects.all(),
    })


# ─────────────────────────────────────────────
# SALES DELETE
# ─────────────────────────────────────────────
def sales_delete(request, transaction_id):
    sale = get_object_or_404(SalesTransaction, transaction_id=transaction_id)
    if request.method == 'POST':
        sale.delete()
        messages.success(request, f'Sale #{transaction_id} has been deleted.')
        return redirect('sales_db')
    return redirect('sales_update', transaction_id=transaction_id)


# ─────────────────────────────────────────────
# PRODUCT ADD
# ─────────────────────────────────────────────
def product_add(request):
    suppliers = Supplier.objects.all().order_by('supplier_name')

    if request.method == 'POST':
        errors = []

        name = request.POST.get('product_name', '').strip()
        ptype = request.POST.get('product_type', '').strip()
        cost = request.POST.get('unit_cost', '').strip()
        supplier_id = request.POST.get('supplier', '').strip()

        if not name:
            errors.append('Product name is required.')
        if not ptype:
            errors.append('Product type is required.')
        if not cost:
            errors.append('Unit cost is required.')
        else:
            try:
                cost_val = float(cost)
                if cost_val < 0:
                    errors.append('Unit cost cannot be negative.')
            except ValueError:
                errors.append('Unit cost must be a valid number.')
        if not supplier_id:
            errors.append('Please select a supplier.')

        if not errors:
            if Product.objects.filter(product_name__iexact=name).exists():
                errors.append(f'A product named "{name}" already exists.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return render(request, 'clinic/product_add.html', {
                'suppliers': suppliers,
                'form_data': request.POST,
            })

        Product.objects.create(
            product_name=name,
            product_type=ptype,
            description=request.POST.get('description', '').strip(),
            unit_cost=cost,
            supplier_id=supplier_id,
        )
        messages.success(request, f'Product "{name}" added successfully.')
        return redirect('product_add')

    return render(request, 'clinic/product_add.html', {
        'suppliers': suppliers,
        'form_data': {},
    })


# ─────────────────────────────────────────────
# SUPPLIER DATABASE
# ─────────────────────────────────────────────
def supplier_db(request):
    query = request.GET.get("q", "").strip()
    suppliers = Supplier.objects.all()
    if query:
        suppliers = suppliers.filter(
            Q(supplier_name__icontains=query) |
            Q(contact_person__icontains=query) |
            Q(supplier_address__icontains=query)
        )
    suppliers = suppliers.order_by("supplier_name")
    return render(request, "clinic/supplier_db.html", {
        "suppliers": suppliers,
        "query": query,
    })


# ─────────────────────────────────────────────
# SUPPLIER DETAILS
# ─────────────────────────────────────────────
def supplier_details(request, supplier_id):
    supplier = get_object_or_404(Supplier, supplier_id=supplier_id)
    products = Product.objects.filter(supplier=supplier).order_by('product_name')
    return render(request, 'clinic/supplier_details.html', {
        'supplier': supplier,
        'products': products,
    })


# ─────────────────────────────────────────────
# SUPPLIER ADD
# ─────────────────────────────────────────────
def supplier_add(request):
    if request.method == 'POST':
        errors = []

        name = request.POST.get('supplier_name', '').strip()
        contact_person = request.POST.get('contact_person', '').strip()
        contact_number = request.POST.get('supplier_contact_number', '').strip()
        address = request.POST.get('supplier_address', '').strip()

        if not name:
            errors.append('Supplier Name is required.')
        if not contact_person:
            errors.append('Contact Person is required.')
        if not contact_number:
            errors.append('Supplier Contact Number is required.')
        if not address:
            errors.append('Supplier Address is required.')

        if contact_number and (not contact_number.isdigit() or len(contact_number) != 11):
            errors.append('Invalid Supplier Contact Number Length. Must be 11 digits.')

        if name and len(name) > 150:
            errors.append('Supplier Name exceeds maximum character length.')
        if contact_person and len(contact_person) > 100:
            errors.append('Contact Person name exceeds maximum character length.')
        if address and len(address) > 300:
            errors.append('Supplier Address exceeds maximum character length.')

        if not errors and Supplier.objects.filter(supplier_name__iexact=name).exists():
            errors.append(f'Supplier "{name}" already exists.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return redirect('supplier_db')

        Supplier.objects.create(
            supplier_name=name,
            contact_person=contact_person,
            supplier_contact_number=contact_number,
            supplier_address=address,
        )
        messages.success(request, f'Supplier "{name}" added successfully.')
        return redirect('supplier_db')

    return redirect('supplier_db')


# ─────────────────────────────────────────────
# SUPPLIER UPDATE
# ─────────────────────────────────────────────
def supplier_update(request, supplier_id):
    supplier = get_object_or_404(Supplier, supplier_id=supplier_id)

    if request.method == 'POST':
        errors = []

        name = request.POST.get('supplier_name', '').strip()
        contact_person = request.POST.get('contact_person', '').strip()
        contact_number = request.POST.get('supplier_contact_number', '').strip()
        address = request.POST.get('supplier_address', '').strip()

        if not name:
            errors.append('Supplier Name is required.')
        if not contact_person:
            errors.append('Contact Person is required.')
        if not contact_number:
            errors.append('Supplier Contact Number is required.')
        if not address:
            errors.append('Supplier Address is required.')

        if contact_number and (not contact_number.isdigit() or len(contact_number) != 11):
            errors.append('Invalid Supplier Contact Number Length. Must be 11 digits.')

        if name and len(name) > 150:
            errors.append('Supplier Name exceeds maximum character length.')
        if contact_person and len(contact_person) > 100:
            errors.append('Contact Person name exceeds maximum character length.')
        if address and len(address) > 300:
            errors.append('Supplier Address exceeds maximum character length.')

        if not errors:
            duplicate = Supplier.objects.filter(supplier_name__iexact=name).exclude(supplier_id=supplier_id)
            if duplicate.exists():
                errors.append(f'Supplier "{name}" already exists.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return redirect('supplier_db')

        supplier.supplier_name = name
        supplier.contact_person = contact_person
        supplier.supplier_contact_number = contact_number
        supplier.supplier_address = address
        supplier.save()

        messages.success(request, f'Supplier "{name}" updated successfully.')
        return redirect('supplier_db')

    return redirect('supplier_db')


# ─────────────────────────────────────────────
# INVENTORY DATABASE
# ─────────────────────────────────────────────
def inventory_db(request):
    query = request.GET.get("q", "").strip()
    date_filter = request.GET.get("date", "").strip()

    shipments = InventoryShipment.objects.all().select_related("supplier", "branch").prefetch_related("receivedproduct_set__product")

    if query:
        shipments = shipments.filter(
            Q(received_product_name__icontains=query) |
            Q(supplier__supplier_name__icontains=query) |
            Q(branch__branch_location__icontains=query)
        )

    if date_filter:
        try:
            if " to " in date_filter:
                start_str, end_str = date_filter.split(" to ")
                start_date = datetime.strptime(start_str.strip(), "%Y-%m-%d").date()
                end_date = datetime.strptime(end_str.strip(), "%Y-%m-%d").date()
                shipments = shipments.filter(date_received__range=[start_date, end_date])
            else:
                single_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
                shipments = shipments.filter(date_received=single_date)
        except ValueError:
            pass

    shipments = shipments.order_by("-date_received")

    for shipment in shipments:
        shipment.received_products = shipment.receivedproduct_set.select_related('product').all()

    return render(request, "clinic/inventory_db.html", {
        "shipments": shipments,
        "query": query,
        "date_filter": date_filter,
        "products": Product.objects.all().order_by('product_name'),
        "suppliers": Supplier.objects.all().order_by('supplier_name'),
        "branches": ClinicBranch.objects.all().order_by('branch_location'),
    })


# ─────────────────────────────────────────────
# INVENTORY DETAILS
# ─────────────────────────────────────────────
def inventory_details(request, inventory_record_id):
    shipment = get_object_or_404(
        InventoryShipment.objects.select_related('supplier', 'branch'),
        inventory_record_id=inventory_record_id
    )
    received_products = ReceivedProduct.objects.filter(
        inventory_record=shipment
    ).select_related('product')

    return render(request, 'clinic/inventory_details.html', {
        'shipment': shipment,
        'received_products': received_products,
    })


# ─────────────────────────────────────────────
# INVENTORY ADD
# ─────────────────────────────────────────────
def inventory_add(request):
    if request.method == 'POST':
        errors = []

        product_id = request.POST.get('product', '').strip()
        qty_received = request.POST.get('quantity_received', '').strip()
        date_received = request.POST.get('date_received', '').strip()
        expiration_date = request.POST.get('expiration_date', '').strip()
        supplier_id = request.POST.get('supplier', '').strip()
        branch_id = request.POST.get('branch', '').strip()

        if not product_id:
            errors.append('Product is required.')
        if not qty_received:
            errors.append('Quantity Received is required.')
        if not date_received:
            errors.append('Date Received is required.')
        if not expiration_date:
            errors.append('Expiration Date is required.')
        if not supplier_id:
            errors.append('Supplier is required.')
        if not branch_id:
            errors.append('Branch is required.')

        qty_val = None
        if qty_received:
            try:
                qty_val = int(qty_received)
                if qty_val < 1:
                    errors.append('Quantity Received must be at least 1.')
                elif qty_val > 10000:
                    errors.append('Quantity exceeds maximum allowable limit of 10,000.')
            except ValueError:
                errors.append('Quantity Received must be a valid number.')

        if expiration_date:
            try:
                exp_date = datetime.strptime(expiration_date, "%Y-%m-%d").date()
                from datetime import date
                if exp_date < date(2000, 1, 1):
                    errors.append('Expiration date must be from Jan 1, 2000 onwards.')
            except ValueError:
                errors.append('Invalid expiration date format.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return redirect('inventory_db')

        try:
            with transaction.atomic():
                product = Product.objects.get(pk=product_id)
                supplier = Supplier.objects.get(pk=supplier_id)
                branch = ClinicBranch.objects.get(pk=branch_id)

                shipment = InventoryShipment.objects.create(
                    received_product_name=product.product_name,
                    date_received=date_received,
                    supplier=supplier,
                    branch=branch,
                )

                ReceivedProduct.objects.create(
                    inventory_record=shipment,
                    product=product,
                    quantity_received=qty_val,
                    expiration_date=expiration_date,
                    branch=branch,
                )

                branch_product, created = BranchProduct.objects.get_or_create(
                    branch=branch,
                    product=product,
                    defaults={'stock_quantity': 0, 'quantity_minimum': 0}
                )

                if branch_product.stock_quantity + qty_val > 10000:
                    raise ValueError('Receiving this shipment will exceed the maximum branch stock capacity of 10,000.')

                branch_product.stock_quantity += qty_val
                branch_product.save()

            messages.success(request, 'Inventory shipment recorded successfully.')
            return redirect('inventory_db')

        except ValueError as e:
            messages.error(request, str(e))
            return redirect('inventory_db')
        except Exception as e:
            messages.error(request, f'An error occurred: {str(e)}')
            return redirect('inventory_db')

    return redirect('inventory_db')


# ─────────────────────────────────────────────
# INVENTORY UPDATE
# ─────────────────────────────────────────────
def inventory_update(request, inventory_record_id):
    shipment = get_object_or_404(
        InventoryShipment.objects.select_related('supplier', 'branch'),
        inventory_record_id=inventory_record_id
    )
    received_product = ReceivedProduct.objects.filter(inventory_record=shipment).select_related('product').first()

    if request.method == 'POST':
        errors = []

        product_id = request.POST.get('product', '').strip()
        qty_received = request.POST.get('quantity_received', '').strip()
        date_received = request.POST.get('date_received', '').strip()
        expiration_date = request.POST.get('expiration_date', '').strip()
        supplier_id = request.POST.get('supplier', '').strip()
        branch_id = request.POST.get('branch', '').strip()

        if not product_id:
            errors.append('Product is required.')
        if not qty_received:
            errors.append('Quantity Received is required.')
        if not date_received:
            errors.append('Date Received is required.')
        if not expiration_date:
            errors.append('Expiration Date is required.')
        if not supplier_id:
            errors.append('Supplier is required.')
        if not branch_id:
            errors.append('Branch is required.')

        qty_val = None
        if qty_received:
            try:
                qty_val = int(qty_received)
                if qty_val < 1:
                    errors.append('Quantity Received must be at least 1.')
                elif qty_val > 10000:
                    errors.append('Quantity exceeds maximum allowable limit of 10,000.')
            except ValueError:
                errors.append('Quantity Received must be a valid number.')

        if expiration_date:
            try:
                exp_date = datetime.strptime(expiration_date, "%Y-%m-%d").date()
                from datetime import date
                if exp_date < date(2000, 1, 1):
                    errors.append('Expiration date must be from Jan 1, 2000 onwards.')
            except ValueError:
                errors.append('Invalid expiration date format.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return redirect('inventory_db')

        try:
            with transaction.atomic():
                product = Product.objects.get(pk=product_id)
                supplier = Supplier.objects.get(pk=supplier_id)
                branch = ClinicBranch.objects.get(pk=branch_id)

                old_qty = received_product.quantity_received if received_product else 0
                old_branch = shipment.branch
                old_product = received_product.product if received_product else None

                shipment.received_product_name = product.product_name
                shipment.date_received = date_received
                shipment.supplier = supplier
                shipment.branch = branch
                shipment.save()

                if received_product:
                    if old_product and old_branch:
                        old_bp = BranchProduct.objects.filter(branch=old_branch, product=old_product).first()
                        if old_bp:
                            old_bp.stock_quantity = max(0, old_bp.stock_quantity - old_qty)
                            old_bp.save()

                    received_product.product = product
                    received_product.quantity_received = qty_val
                    received_product.expiration_date = expiration_date
                    received_product.branch = branch
                    received_product.save()

                    new_bp, created = BranchProduct.objects.get_or_create(
                        branch=branch,
                        product=product,
                        defaults={'stock_quantity': 0, 'quantity_minimum': 0}
                    )
                    if new_bp.stock_quantity + qty_val > 10000:
                        raise ValueError('Receiving this shipment will exceed the maximum branch stock capacity of 10,000.')
                    new_bp.stock_quantity += qty_val
                    new_bp.save()

            messages.success(request, f'Inventory record #{inventory_record_id} updated successfully.')
            return redirect('inventory_db')

        except ValueError as e:
            messages.error(request, str(e))
            return redirect('inventory_db')
        except Exception as e:
            messages.error(request, f'An error occurred: {str(e)}')
            return redirect('inventory_db')

    return redirect('inventory_db')