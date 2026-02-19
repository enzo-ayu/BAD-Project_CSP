from django.shortcuts import render, redirect, get_object_or_404
from django.db import transaction
from django.db.models import Q
from django.contrib import messages
from datetime import datetime
from .models import Patient, Product, Treatment, SalesTransaction, TransactionItem, PatientVisit, ClinicBranch, Supplier


# ─────────────────────────────────────────────
# CHARGESLIP (Create New Sale)
# ─────────────────────────────────────────────
def chargeslip(request):
    if request.method == 'POST':
        errors = []

        is_new_patient = request.POST.get('is_new_patient') == 'true'

        # ── Validate patient ──
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

        # ── Validate mode of payment ──
        if not request.POST.get('mode_of_payment', '').strip():
            errors.append('Please select a mode of payment.')

        # ── Validate at least one item ──
        product_ids = [p for p in request.POST.getlist('actual_product_ids') if p]
        treatment_ids = [t for t in request.POST.getlist('actual_treatment_ids') if t]
        if not product_ids and not treatment_ids:
            errors.append('Please add at least one product or treatment.')

        # ── Validate quantities ──
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

        # ── Save data ──
        try:
            with transaction.atomic():
                if is_new_patient:
                    # Check duplicate patient
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
                        suffix=request.POST.get('suffix', '').strip() or None,
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
                )

                branch = ClinicBranch.objects.first()
                notes = request.POST.get('notes', '').strip()
                if notes and branch:
                    visit, _ = PatientVisit.objects.get_or_create(patient=patient, branch=branch)
                    visit.patient_notes = notes
                    visit.save()

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
            return redirect('sales_db')

        except Exception as e:
            messages.error(request, f'An error occurred while saving: {str(e)}')

    patients = Patient.objects.all().order_by('last_name')
    products = Product.objects.all().order_by('product_name')
    treatments = Treatment.objects.all().order_by('treatment_name')
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
# PATIENT ADD (standalone form)
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
            # Check for duplicate
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
            suffix=request.POST.get('suffix', '').strip() or None,
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
        patient.suffix = request.POST.get('suffix', '').strip() or None
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
    # If someone tries GET, redirect back
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
def view_chargeslip(request, transaction_id):
    sale = get_object_or_404(
        SalesTransaction.objects.select_related('patient'),
        transaction_id=transaction_id,
    )
    items = TransactionItem.objects.filter(transaction=sale).select_related('product', 'treatment')
    products = [i for i in items if i.product]
    treatments = [i for i in items if i.treatment]
    product_total = sum(i.subtotal for i in products)
    treatment_total = sum(i.subtotal for i in treatments)
    visit = PatientVisit.objects.filter(patient=sale.patient).first()
    notes = visit.patient_notes if visit else None

    return render(request, 'clinic/chargeslip_view.html', {
        'transaction': sale,
        'patient': sale.patient,
        'products': products,
        'treatments': treatments,
        'product_total': product_total,
        'treatment_total': treatment_total,
        'notes': notes,
    })


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