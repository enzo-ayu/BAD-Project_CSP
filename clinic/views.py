from django.shortcuts import render, redirect, get_object_or_404
from django.db import transaction
from django.db.models import Q
from django.contrib import messages
from datetime import datetime
from django.urls import reverse

# Auth and Access Built-ins
from django.contrib.auth.models import User, Group
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth import update_session_auth_hash

# Local Models and Forms
from .models import (
    Patient, Product, Treatment, SalesTransaction, TransactionItem, 
    ClinicBranch, Supplier, EmployeeProfile, InventoryShipment, ReceivedProduct
)
from .forms import RoleBasedRegistrationForm


# ─────────────────────────────────────────────
# HELPER FUNCTIONS
# ─────────────────────────────────────────────
def is_owner(user):
    """Check if the logged-in user belongs to the 'Owner' group."""
    return user.groups.filter(name='Owner').exists()


# ─────────────────────────────────────────────
# CHARGESLIP (Create New Sale)
# ─────────────────────────────────────────────
@login_required(login_url='login')
def chargeslip(request):
    if request.method == 'POST':
        errors = []
        is_new_patient = request.POST.get('is_new_patient') == 'true'
        notes = request.POST.get('notes', '').strip()

        # ── Validate Patient ──
        if is_new_patient:
            required_new = {
                'last_name': 'Last Name', 'first_name': 'First Name',
                'birthday': 'Birthday', 'sex': 'Sex',
                'address': 'Address', 'contact': 'Contact Number',
            }
            for field, label in required_new.items():
                if not request.POST.get(field, '').strip():
                    errors.append(f'{label} is required for new patients.')
        else:
            if not request.POST.get('patient', '').strip():
                errors.append('Please select an existing patient or register a new one.')

        # ── Validate Payment & Items ──
        if not request.POST.get('mode_of_payment', '').strip():
            errors.append('Please select a mode of payment.')

        product_ids = [p for p in request.POST.getlist('actual_product_ids') if p]
        treatment_ids = [t for t in request.POST.getlist('actual_treatment_ids') if t]
        
        if not product_ids and not treatment_ids:
            errors.append('Please add at least one product or treatment.')

        # ── Validate Quantities ──
        for qty in request.POST.getlist('product_qtys') + request.POST.getlist('treatment_qtys'):
            try:
                if int(qty) < 1:
                    errors.append('All quantities must be at least 1.')
                    break
            except (ValueError, TypeError):
                errors.append('Invalid quantity entered.')
                break

        # ── Handle Errors ──
        if errors:
            for error in errors:
                messages.error(request, error)
            return render(request, 'clinic/chargeslip.html', {
                'patients': Patient.objects.all().order_by('last_name'),
                'products': Product.objects.all().order_by('product_name'),
                'treatments': Treatment.objects.all().order_by('treatment_name'),
            })

# ── Save Data ──
        try:
            from .models import BranchProduct
            try:
                employee_branch = request.user.employeeprofile.branch
                if not employee_branch:
                    employee_branch = ClinicBranch.objects.first()
            except:
                raise Exception("Your account has no assigned branch. Please contact the owner.")

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

                total_products = 0.0
                total_treatments = 0.0

                product_qtys = request.POST.getlist('product_qtys')
                treatment_qtys = request.POST.getlist('treatment_qtys')

                sale = SalesTransaction.objects.create(
                    patient=patient,
                    total_price_of_products=0,
                    total_price_of_treatments=0,
                    total_amount=0,
                    mode_of_payment=request.POST.get('mode_of_payment'),
                    notes=notes
                )

                # Process Products
                for pid, qty in zip(product_ids, product_qtys):
                    if pid:
                        product = Product.objects.get(pk=pid)
                        q = int(qty)

                        branch_product = BranchProduct.objects.filter(
                            product=product, branch=employee_branch
                        ).first()

                        if not branch_product or branch_product.stock_quantity < q:
                            available = branch_product.stock_quantity if branch_product else 0
                            raise Exception(f"Not enough stock for {product.product_name}. Available: {available}")

                        branch_product.stock_quantity -= q
                        branch_product.save()

                        subtotal = float(product.unit_cost) * q
                        total_products += subtotal

                        TransactionItem.objects.create(
                            transaction=sale,
                            product=product,
                            quantity_purchased=q,
                            subtotal=subtotal
                        )

                # Process Treatments
                for tid, qty in zip(treatment_ids, treatment_qtys):
                    if tid:
                        treatment = Treatment.objects.get(pk=tid)
                        q = int(qty)
                        subtotal = float(treatment.treatment_cost) * q
                        total_treatments += subtotal
                        TransactionItem.objects.create(
                            transaction=sale, treatment=treatment,
                            quantity_purchased=q, subtotal=subtotal
                        )

                sale.total_price_of_products = total_products
                sale.total_price_of_treatments = total_treatments
                sale.total_amount = total_products + total_treatments
                sale.save()

            messages.success(request, 'Charge slip saved successfully.')
            return redirect('patient_db')

        except Exception as e:
            messages.error(request, f'An error occurred while saving: {str(e)}')

    # ── GET Request handling ──
    return render(request, 'clinic/chargeslip.html', {
        'patients': Patient.objects.all().order_by('last_name'),
        'products': Product.objects.all().order_by('product_type', 'product_name'),
        'treatments': Treatment.objects.all().order_by('treatment_type', 'treatment_name'),
    })


# ─────────────────────────────────────────────
# PATIENT VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
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
    
    return render(request, "clinic/patient_db.html", {
        "patients": patients.order_by("last_name", "first_name"),
        "query": query,
    })

@login_required(login_url='login')
def patient_details(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)
    transactions = SalesTransaction.objects.filter(patient=patient).order_by('-transaction_date')
    return render(request, 'clinic/patient_details.html', {
        'patient': patient,
        'transactions': transactions,
    })

@login_required(login_url='login')
def patient_add(request):
    if request.method == 'POST':
        required_fields = {
            'last_name': 'Last Name', 'first_name': 'First Name',
            'patient_address': 'Address', 'patient_contact_number': 'Contact Number',
            'birthday': 'Birthday', 'sex': 'Sex'
        }
        
        errors = [f'{label} is required.' for field, label in required_fields.items() if not request.POST.get(field, '').strip()]
        
        last = request.POST.get('last_name', '').strip()
        first = request.POST.get('first_name', '').strip()
        birthday = request.POST.get('birthday', '').strip()

        if not errors and Patient.objects.filter(last_name__iexact=last, first_name__iexact=first, birthday=birthday).exists():
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
            patient_address=request.POST.get('patient_address', '').strip(),
            patient_contact_number=request.POST.get('patient_contact_number', '').strip(),
            birthday=birthday,
            sex=request.POST.get('sex', '').strip(),
        )
        messages.success(request, f'Patient {first} {last} added successfully.')
        return redirect('patient_db')

    return render(request, 'clinic/patient_add.html', {'form_data': {}})

@login_required(login_url='login')
def patient_update(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)

    if request.method == 'POST':
        required_fields = {
            'last_name': 'Last Name', 'first_name': 'First Name',
            'patient_address': 'Address', 'patient_contact_number': 'Contact Number',
            'birthday': 'Birthday', 'sex': 'Sex'
        }
        
        errors = [f'{label} is required.' for field, label in required_fields.items() if not request.POST.get(field, '').strip()]

        if errors:
            for error in errors:
                messages.error(request, error)
            return render(request, 'clinic/patient_update.html', {'patient': patient})

        patient.last_name = request.POST.get('last_name', '').strip()
        patient.first_name = request.POST.get('first_name', '').strip()
        patient.middle_name = request.POST.get('middle_name', '').strip()
        patient.suffix = request.POST.get('suffix', '').strip() or ""
        patient.patient_address = request.POST.get('patient_address', '').strip()
        patient.patient_contact_number = request.POST.get('patient_contact_number', '').strip()
        patient.birthday = request.POST.get('birthday', '').strip()
        patient.sex = request.POST.get('sex', '').strip()
        patient.save()

        messages.success(request, f'Patient {patient.first_name} {patient.last_name} updated successfully.')
        return redirect('patient_db')

    return render(request, 'clinic/patient_update.html', {'patient': patient})

@login_required(login_url='login')
def patient_delete(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)
    if request.method == 'POST':
        name = f'{patient.first_name} {patient.last_name}'
        patient.delete()
        messages.success(request, f'Patient {name} has been deleted.')
        return redirect('patient_db')
    return redirect('patient_update', patient_id=patient_id)


# ─────────────────────────────────────────────
# SALES & CHARGESLIP VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
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

    return render(request, "clinic/sales_db.html", {
        "sales": sales.order_by("-transaction_date"),
        "query": query,
        "date_filter": date_filter,
    })

def _get_chargeslip_context(transaction_id):
    sale = get_object_or_404(SalesTransaction.objects.select_related('patient'), transaction_id=transaction_id)
    items = TransactionItem.objects.filter(transaction=sale).select_related('product', 'treatment')
    products = [i for i in items if i.product]
    treatments = [i for i in items if i.treatment]

    return {
        'transaction': sale,
        'patient': sale.patient,
        'products': products,
        'treatments': treatments,
        'product_total': sum(i.subtotal for i in products),
        'treatment_total': sum(i.subtotal for i in treatments),
        'notes': sale.notes,
    }

@login_required(login_url='login')
def view_chargeslip_patient(request, transaction_id):
    return render(request, 'clinic/chargeslip_view.html', _get_chargeslip_context(transaction_id))

@login_required(login_url='login')
def view_chargeslip_sales(request, transaction_id):
    return render(request, 'clinic/chargeslip_view_sales.html', _get_chargeslip_context(transaction_id))

@login_required(login_url='login')
def sales_update(request, transaction_id):
    sale = get_object_or_404(SalesTransaction, transaction_id=transaction_id)

    if request.method == 'POST':
        errors = []
        transaction_date = request.POST.get('transaction_date', '').strip()
        mode_of_payment = request.POST.get('mode_of_payment', '').strip()
        product_ids = [p for p in request.POST.getlist('product_ids') if p]
        treatment_ids = [t for t in request.POST.getlist('treatment_ids') if t]

        if not transaction_date: errors.append('Transaction date is required.')
        if not mode_of_payment: errors.append('Mode of payment is required.')
        if not product_ids and not treatment_ids: errors.append('Please add at least one product or treatment.')

        if errors:
            for error in errors:
                messages.error(request, error)
        else:
            try:
                from .models import BranchProduct
                try:
                    employee_branch = request.user.employeeprofile.branch
                    if not employee_branch:
                        employee_branch = ClinicBranch.objects.first()
                except:
                    employee_branch = ClinicBranch.objects.first()

                with transaction.atomic():
                    sale.transaction_date = transaction_date
                    sale.mode_of_payment = mode_of_payment
                    sale.save()

                    # Reverse old stock deductions
                    old_items = TransactionItem.objects.filter(transaction=sale).select_related('product')
                    for item in old_items:
                        if item.product:
                            bp = BranchProduct.objects.filter(
                                product=item.product, branch=employee_branch
                            ).first()
                            if bp:
                                bp.stock_quantity += item.quantity_purchased
                                bp.save()

                    TransactionItem.objects.filter(transaction=sale).delete()

                    total_products, total_treatments = 0.0, 0.0

                    for pid, qty in zip(product_ids, request.POST.getlist('product_qtys')):
                        if pid and qty:
                            product = Product.objects.get(pk=pid)
                            q = int(qty)

                            bp = BranchProduct.objects.filter(
                                product=product, branch=employee_branch
                            ).first()
                            if not bp or bp.stock_quantity < q:
                                available = bp.stock_quantity if bp else 0
                                raise Exception(f"Not enough stock for {product.product_name}. Available: {available}")

                            bp.stock_quantity -= q
                            bp.save()

                            subtotal = float(product.unit_cost) * q
                            TransactionItem.objects.create(transaction=sale, product=product, quantity_purchased=q, subtotal=subtotal)
                            total_products += subtotal

                    for tid, qty in zip(treatment_ids, request.POST.getlist('treatment_qtys')):
                        if tid and qty:
                            treatment = Treatment.objects.get(pk=tid)
                            subtotal = float(treatment.treatment_cost) * int(qty)
                            TransactionItem.objects.create(transaction=sale, treatment=treatment, quantity_purchased=int(qty), subtotal=subtotal)
                            total_treatments += subtotal

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

@login_required(login_url='login')
def sales_delete(request, transaction_id):
    sale = get_object_or_404(SalesTransaction, transaction_id=transaction_id)
    if request.method == 'POST':
        from .models import BranchProduct
        try:
            employee_branch = request.user.employeeprofile.branch
            if not employee_branch:
                employee_branch = ClinicBranch.objects.first()
        except:
            employee_branch = ClinicBranch.objects.first()

        with transaction.atomic():
            items = TransactionItem.objects.filter(transaction=sale).select_related('product')
            for item in items:
                if item.product:
                    bp = BranchProduct.objects.filter(
                        product=item.product, branch=employee_branch
                    ).first()
                    if bp:
                        bp.stock_quantity += item.quantity_purchased
                        bp.save()
            sale.delete()

        messages.success(request, f'Sale #{transaction_id} has been deleted.')
        return redirect('sales_db')
    return redirect('sales_update', transaction_id=transaction_id)


# ─────────────────────────────────────────────
# INVENTORY VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
def inventory_db(request):
    query = request.GET.get("q", "").strip()
    date_filter = request.GET.get("date", "").strip()

    shipments = InventoryShipment.objects.select_related(
        'supplier', 'branch'
    ).prefetch_related('received_products__product').all()

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

    return render(request, 'clinic/inventory_db.html', {
        'shipments': shipments.order_by('-date_received'),
        'products': Product.objects.all().order_by('product_name'),
        'suppliers': Supplier.objects.all().order_by('supplier_name'),
        'branches': ClinicBranch.objects.all().order_by('branch_location'),
        'query': query,
        'date_filter': date_filter,
    })


@login_required(login_url='login')
def inventory_add(request):
    if request.method == 'POST':
        try:
            product_id = request.POST.get('product')
            product = Product.objects.get(pk=product_id)

            from .models import BranchProduct
            branch_id = request.POST.get('branch')
            quantity_received = int(request.POST.get('quantity_received'))

            with transaction.atomic():
                shipment = InventoryShipment.objects.create(
                    received_product_name=product.product_name,
                    date_received=request.POST.get('date_received'),
                    supplier_id=request.POST.get('supplier'),
                    branch_id=branch_id,
                )
                ReceivedProduct.objects.create(
                    inventory_record=shipment,
                    product=product,
                    quantity_received=quantity_received,
                    expiration_date=request.POST.get('expiration_date'),
                    branch_id=branch_id,
                )

                # Increase BranchProduct stock
                branch_product, created = BranchProduct.objects.get_or_create(
                    product=product,
                    branch_id=branch_id,
                    defaults={'stock_quantity': 0, 'quantity_minimum': 0}
                )
                branch_product.stock_quantity += quantity_received
                branch_product.save()

            messages.success(request, 'Shipment added successfully.')
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')
    return redirect('inventory_db')


@login_required(login_url='login')
def inventory_update(request, record_id):
    if request.method == 'POST':
        from .models import BranchProduct
        shipment = get_object_or_404(InventoryShipment, pk=record_id)
        try:
            product_id = request.POST.get('product')
            product = Product.objects.get(pk=product_id)
            new_qty = int(request.POST.get('quantity_received'))
            new_branch_id = request.POST.get('branch')

            with transaction.atomic():
                # Reverse old stock
                old_received = ReceivedProduct.objects.filter(inventory_record=shipment).first()
                if old_received:
                    old_bp = BranchProduct.objects.filter(
                        product=old_received.product,
                        branch=shipment.branch
                    ).first()
                    if old_bp:
                        old_bp.stock_quantity -= old_received.quantity_received
                        if old_bp.stock_quantity < 0:
                            old_bp.stock_quantity = 0
                        old_bp.save()

                # Update shipment
                shipment.received_product_name = product.product_name
                shipment.date_received = request.POST.get('date_received')
                shipment.supplier_id = request.POST.get('supplier')
                shipment.branch_id = new_branch_id
                shipment.save()

                # Update received product record
                if old_received:
                    old_received.product = product
                    old_received.quantity_received = new_qty
                    old_received.expiration_date = request.POST.get('expiration_date')
                    old_received.branch_id = new_branch_id
                    old_received.save()
                else:
                    ReceivedProduct.objects.create(
                        inventory_record=shipment,
                        product=product,
                        quantity_received=new_qty,
                        expiration_date=request.POST.get('expiration_date'),
                        branch_id=new_branch_id,
                    )

                # Apply new stock
                new_bp, created = BranchProduct.objects.get_or_create(
                    product=product,
                    branch_id=new_branch_id,
                    defaults={'stock_quantity': 0, 'quantity_minimum': 0}
                )
                new_bp.stock_quantity += new_qty
                new_bp.save()

            messages.success(request, 'Shipment updated successfully.')
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')
    return redirect('inventory_db')


@login_required(login_url='login')
def inventory_delete(request, record_id):
    if request.method == 'POST':
        from .models import BranchProduct
        shipment = get_object_or_404(InventoryShipment, pk=record_id)
        try:
            with transaction.atomic():
                for received in shipment.received_products.all():
                    branch_product = BranchProduct.objects.filter(
                        product=received.product,
                        branch=shipment.branch
                    ).first()
                    if branch_product:
                        branch_product.stock_quantity -= received.quantity_received
                        if branch_product.stock_quantity < 0:
                            branch_product.stock_quantity = 0
                        branch_product.save()
                shipment.delete()
            messages.success(request, 'Inventory record deleted and stock reversed.')
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')
    return redirect('inventory_db')


@login_required(login_url='login')
def inventory_details(request, record_id):
    shipment = get_object_or_404(
        InventoryShipment.objects.select_related('supplier', 'branch')
        .prefetch_related('received_products__product'),
        pk=record_id
    )
    return render(request, 'clinic/inventory_details.html', {
        'shipment': shipment,
    })
# ─────────────────────────────────────────────
# PRODUCT TREATMENT
# ─────────────────────────────────────────────
@login_required(login_url='login')
def producttreatment_db(request):

    # ================= GET PARAMETERS =================
    product_query = request.GET.get("product_q", "").strip()
    treatment_query = request.GET.get("treatment_q", "").strip()

    product_sort = request.GET.get("product_sort", "")
    treatment_sort = request.GET.get("treatment_sort", "")

    product_type = request.GET.get("product_type", "")
    treatment_type = request.GET.get("treatment_type", "")

    # ================= BASE QUERYSETS =================
    products = Product.objects.all()
    treatments = Treatment.objects.all()

    # ================= SEARCH =================
    if product_query:
        products = products.filter(
            Q(product_name__icontains=product_query) |
            Q(product_type__icontains=product_query)
        )

    if treatment_query:
        treatments = treatments.filter(
            Q(treatment_name__icontains=treatment_query) |
            Q(treatment_type__icontains=treatment_query)
        )

    # ================= TYPE FILTER =================
    if product_type:
        products = products.filter(product_type=product_type)

    if treatment_type:
        treatments = treatments.filter(treatment_type=treatment_type)

    # ================= SORTING =================
    # PRODUCTS
    if product_sort == "price_desc":
        products = products.order_by('-unit_cost')
    elif product_sort == "price_asc":
        products = products.order_by('unit_cost')
    elif product_sort == "name_desc":
        products = products.order_by('-product_name')
    else:
        products = products.order_by('product_name')  # default

    # TREATMENTS
    if treatment_sort == "price_desc":
        treatments = treatments.order_by('-treatment_cost')
    elif treatment_sort == "price_asc":
        treatments = treatments.order_by('treatment_cost')
    elif treatment_sort == "name_desc":
        treatments = treatments.order_by('-treatment_name')
    else:
        treatments = treatments.order_by('treatment_name')  # default

# ================= DROPDOWN VALUES =================
    product_types = Product.objects.values_list('product_type', flat=True).distinct()
    treatment_types = Treatment.objects.values_list('treatment_type', flat=True).distinct()

# ================= BRANCH STOCK =================
    from .models import BranchProduct
    try:
        employee_branch = request.user.employeeprofile.branch
        if not employee_branch:
            employee_branch = ClinicBranch.objects.first()
        branch_stock = BranchProduct.objects.filter(
            branch=employee_branch
        ).values('product_id', 'stock_quantity', 'quantity_minimum')
        stock_map = {bp['product_id']: bp for bp in branch_stock}
    except:
        stock_map = {}

    for product in products:
        bp = stock_map.get(product.product_id)
        product.branch_stock = bp['stock_quantity'] if bp else 0
        product.branch_minimum = bp['quantity_minimum'] if bp else 0
        product.is_low_stock = product.branch_stock <= product.branch_minimum

    return render(request, 'clinic/producttreatment_db.html', {
        'products': products,
        'treatments': treatments,
        # keep values after filtering
        'product_query': product_query,
        'treatment_query': treatment_query,
        'product_sort': product_sort,
        'treatment_sort': treatment_sort,
        'product_type': product_type,
        'treatment_type': treatment_type,

        # dropdowns
        'product_types': product_types,
        'treatment_types': treatment_types,
    })
# ─────────────────────────────────────────────
# PRODUCT VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
def product_add(request):
    suppliers = Supplier.objects.all()
    branches = ClinicBranch.objects.all()
    query_string = request.GET.urlencode()

    if request.method == 'POST':
        name = request.POST.get('product_name', '').strip()
        ptype = request.POST.get('product_type', '').strip()
        desc = request.POST.get('description', '').strip()
        cost = request.POST.get('unit_cost', '').strip()
        stock = request.POST.get('stock_quantity', '').strip()
        min_qty = request.POST.get('quantity_minimum', '').strip()
        supplier_id = request.POST.get('supplier')
        branch_id = request.POST.get('branch')

        if not all([name, ptype, desc, cost, min_qty, supplier_id, branch_id]):
            messages.error(request, "All fields required.")
            return render(request, 'clinic/product_add.html', {
                'suppliers': suppliers,
                'branches': branches
            })

        try:
            from .models import BranchProduct
            product = Product.objects.create(
                product_name=name,
                product_type=ptype,
                description=desc,
                unit_cost=float(cost),
                supplier_id=supplier_id,
            )
            BranchProduct.objects.create(
                product=product,
                branch_id=branch_id,
                stock_quantity=int(stock),
                quantity_minimum=int(min_qty),
            )

            messages.success(request, "Product Added Successfully")
            return redirect('producttreatment_db')

        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

    return render(request, 'clinic/product_add.html', {
        'suppliers': suppliers,
        'branches': branches,
        'query_string': query_string
    })

@login_required(login_url='login')
def product_details(request, product_id):
    from .models import BranchProduct
    product = get_object_or_404(Product, product_id=product_id)
    supplier = Supplier.objects.filter(supplier_id=product.supplier_id).first()
    query_string = request.GET.urlencode()

    try:
        employee_branch = request.user.employeeprofile.branch
        if not employee_branch:
            employee_branch = ClinicBranch.objects.first()
    except:
        employee_branch = ClinicBranch.objects.first()

    branch_product = BranchProduct.objects.filter(
        product=product, branch=employee_branch
    ).first()

    return render(request, 'clinic/product_details.html', {
        'product': product,
        'supplier': supplier,
        'branch': employee_branch,
        'branch_product': branch_product,
        'query_string': query_string
    })

@login_required(login_url='login')
def product_update(request, product_id):
    product = get_object_or_404(Product, product_id=product_id)
    suppliers = Supplier.objects.all()
    branches = ClinicBranch.objects.all()

    product_types = Product.objects.values_list('product_type', flat=True).distinct()
    query_string = request.GET.urlencode()
    if request.method == 'POST':
        errors = []
        name = request.POST.get('product_name', '').strip()
        ptype = request.POST.get('product_type', '').strip()
        desc = request.POST.get('description', '').strip()
        cost = request.POST.get('unit_cost', '').strip()
        min_qty = request.POST.get('quantity_minimum', '').strip()
        supplier_id = request.POST.get('supplier')
        branch_id = request.POST.get('branch')

        # VALIDATION
        if not all([name, ptype, desc, cost, min_qty, supplier_id, branch_id]):
            messages.error(request, "All fields required.")
            return render(request, 'clinic/product_update.html', {
                'product': product,
                'suppliers': suppliers,
                'branches': branches,
                'product_types': product_types 
            })

        try:
            from .models import BranchProduct
            product.product_name = name
            product.product_type = ptype
            product.description = desc
            product.unit_cost = float(cost)
            product.supplier_id = supplier_id
            product.save()

            branch_product, created = BranchProduct.objects.get_or_create(
                product=product,
                branch_id=branch_id,
                defaults={'stock_quantity': 0, 'quantity_minimum': int(min_qty)}
            )
            if not created:
                branch_product.quantity_minimum = int(min_qty)
                branch_product.save()

            messages.success(request, "Update Successful")
            return redirect('producttreatment_db')

        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

    from .models import BranchProduct
    try:
        employee_branch = request.user.employeeprofile.branch
        if not employee_branch:
            employee_branch = ClinicBranch.objects.first()
        branch_product = BranchProduct.objects.filter(
            product=product, branch=employee_branch
        ).first()
    except:
        branch_product = None

    return render(request, 'clinic/product_update.html', {
        'product': product,
        'suppliers': suppliers,
        'branches': branches,
        'product_types': product_types,
        'query_string': query_string,
        'branch_product': branch_product,
    })

@login_required(login_url='login')
def product_delete(request, product_id):
    product = get_object_or_404(Product, product_id=product_id)
    product.delete()
    messages.success(request, "Product deleted successfully")
    return redirect('producttreatment_db')
# ─────────────────────────────────────────────
# TREATMENT VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
def treatment_add(request):
    branches = ClinicBranch.objects.all()
    query_string = request.GET.urlencode()

    if request.method == 'POST':
        name = request.POST.get('treatment_name', '').strip()
        ttype = request.POST.get('treatment_type', '').strip()
        cost = request.POST.get('treatment_cost', '').strip()
        desc = request.POST.get('description', '').strip()
        status = request.POST.get('availability_status')
        branch_id = request.POST.get('branch')

        if not all([name, ttype, cost, desc, branch_id]):
            messages.error(request, "All fields required.")
            return render(request, 'clinic/treatment_add.html', {
                'branches': branches
            })

        try:
            Treatment.objects.create(
                treatment_name=name,
                treatment_type=ttype,
                treatment_cost=float(cost),
                description=desc,
                availability_status=bool(status),
                branch_id=branch_id
            )

            messages.success(request, "Treatment Added Successfully")
            return redirect('producttreatment_db')

        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

    return render(request, 'clinic/treatment_add.html', {
        'branches': branches,
        'query_string': query_string
    })

@login_required(login_url='login')
def treatment_details(request, treatment_id):
    treatment = get_object_or_404(Treatment, treatment_id=treatment_id)
    branch = None
    query_string = request.GET.urlencode()

    return render(request, 'clinic/treatment_details.html', {
        'treatment': treatment,
        'branch': branch,
        'query_string': query_string
    })

@login_required(login_url='login')
def treatment_update(request, treatment_id):
    treatment = get_object_or_404(Treatment, treatment_id=treatment_id)
    branches = ClinicBranch.objects.all()
    query_string = request.GET.urlencode() 

    treatment_types = Treatment.objects.values_list('treatment_type', flat=True).distinct()
    if request.method == 'POST':
        errors = []

        name = request.POST.get('treatment_name', '').strip()
        ttype = request.POST.get('treatment_type', '').strip()
        cost = request.POST.get('treatment_cost', '').strip()
        desc = request.POST.get('description', '').strip()
        status = request.POST.get('availability_status')
        branch_id = request.POST.get('branch')

        if not all([name, ttype, cost, desc, status, branch_id]):
            messages.error(request, "All fields required.")
            return render(request, 'clinic/treatment_update.html', {
                'treatment': treatment,
                'branches': branches,
                'treatment_types': treatment_types   
            })

        try:
            treatment.treatment_name = name
            treatment.treatment_type = ttype
            treatment.treatment_cost = float(cost)
            treatment.description = desc
            treatment.availability_status = status
            treatment.branch_id = branch_id
            treatment.save()

            messages.success(request, "Update Successful")
            return redirect('producttreatment_db')

        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

    return render(request, 'clinic/treatment_update.html', {
        'treatment': treatment,
        'branches': branches,
        'treatment_types': treatment_types,
        'query_string': query_string
    })

@login_required(login_url='login')
def treatment_delete(request, treatment_id):
    treatment = get_object_or_404(Treatment, treatment_id=treatment_id)
    treatment.delete()
    messages.success(request, "Treatment deleted successfully")
    return redirect('producttreatment_db')
# ─────────────────────────────────────────────
# SUPPLIER VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
def supplier_db(request):
    # ── 1. CATCH THE FORM DATA (POST REQUEST) ──
    if request.method == 'POST':
        name = request.POST.get('supplier_name', '').strip()
        person = request.POST.get('contact_person', '').strip()
        number = request.POST.get('supplier_contact_number', '').strip()
        address = request.POST.get('supplier_address', '').strip()

        # Basic validation to ensure required fields aren't empty
        if name and person:
            Supplier.objects.create(
                supplier_name=name,
                contact_person=person,
                supplier_contact_number=number,
                supplier_address=address
            )
            messages.success(request, f'Supplier "{name}" added successfully.')
        else:
            messages.error(request, 'Supplier Name and Contact Person are required.')
            
        # Refresh the page to show the new supplier
        return redirect('supplier_db')

    # ── 2. DISPLAY THE PAGE & SEARCH (GET REQUEST) ──
    query = request.GET.get("q", "").strip()
    suppliers = Supplier.objects.all()

    if query:
        suppliers = suppliers.filter(
            Q(supplier_name__icontains=query) |
            Q(contact_person__icontains=query) # Swapped email for contact_person to match your model better!
        )
        
    return render(request, 'clinic/supplier_db.html', {
        'suppliers': suppliers.order_by('supplier_name'),
        'query': query
    })

@login_required(login_url='login')
def supplier_details(request, supplier_id):
    supplier = get_object_or_404(Supplier, supplier_id=supplier_id)
    # Get products provided by this supplier
    products = Product.objects.filter(supplier=supplier)
    
    return render(request, 'clinic/supplier_details.html', {
        'supplier': supplier,
        'products': products
    })

@login_required(login_url='login')
def supplier_update(request, supplier_id):
    # Find the specific supplier in the database
    supplier = get_object_or_404(Supplier, supplier_id=supplier_id)
    
    if request.method == 'POST':
        # Grab the updated data from the modal
        new_name = request.POST.get('supplier_name', '').strip()
        new_person = request.POST.get('contact_person', '').strip()
        new_number = request.POST.get('supplier_contact_number', '').strip()
        new_address = request.POST.get('supplier_address', '').strip()
        
        # Simple validation just to be safe
        if new_name and new_person:
            supplier.supplier_name = new_name
            supplier.contact_person = new_person
            supplier.supplier_contact_number = new_number
            supplier.supplier_address = new_address
            supplier.save()
            
            messages.success(request, f'Supplier "{supplier.supplier_name}" updated successfully.')
        else:
            messages.error(request, 'Supplier Name and Contact Person cannot be empty.')
            
    return redirect('supplier_db')

# ─────────────────────────────────────────────
# EMPLOYEE VIEWS (Owner Only)
# ─────────────────────────────────────────────
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def employee_list(request):
    last_user = User.objects.order_by('id').last()
    next_account_id = (last_user.id + 1) if last_user else 1

    employees = User.objects.all().order_by('username')
    
    query = request.GET.get('q', '').strip()
    status_filter = request.GET.get('status', '')
    
    if query:
        employees = employees.filter(
            Q(first_name__icontains=query) | 
            Q(username__icontains=query)
        )
        
    if status_filter == 'active':
        employees = employees.filter(is_active=True)
    elif status_filter == 'inactive':
        employees = employees.filter(is_active=False)

    context = {
        'employees': employees,
        'groups': Group.objects.all(),
        'branches': ClinicBranch.objects.all(),
        'next_account_id': next_account_id,
        'query': query,
    }
    
    return render(request, 'clinic/employee_list.html', context)

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def add_employee(request):
    if request.method == 'POST':
        role_name = request.POST.get('role')
        branch_id = request.POST.get('branch_id')
        username = request.POST.get('username', '').strip()
        is_active = request.POST.get('is_active') == 'True'
        password = request.POST.get('password')

        # --- MODIFIED: Just grab the string, no splitting ---
        full_name = request.POST.get('full_name', '').strip()

        try:
            with transaction.atomic():
                if User.objects.filter(username__iexact=username).exists():
                    messages.error(request, f'The username "{username}" is already taken.')
                    return redirect('employee_list')

                # --- MODIFIED: Save the whole name into first_name ---
                user = User.objects.create_user(
                    username=username, 
                    password=password, 
                    is_active=is_active,
                    first_name=full_name,
                    last_name=''
                )

                if role_name:
                    user.groups.add(Group.objects.get(name=role_name))

                branch = ClinicBranch.objects.get(branch_id=branch_id)
                EmployeeProfile.objects.create(user=user, branch=branch)

            messages.success(request, f'Employee {username} was successfully added!')
        except Exception as e:
            messages.error(request, f'An error occurred: {str(e)}')

    return redirect('employee_list')

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def update_employee(request, employee_id):
    if request.method == 'POST':
        user = get_object_or_404(User, id=employee_id)
        role_name = request.POST.get('role')
        branch_id = request.POST.get('branch_id')
        username = request.POST.get('username', '').strip()
        is_active = request.POST.get('is_active') == 'True'
        password = request.POST.get('password', '').strip()
        
        # --- MODIFIED: Just grab the string ---
        full_name = request.POST.get('full_name', '').strip()
        
        try:
            with transaction.atomic():
                if User.objects.filter(username__iexact=username).exclude(id=employee_id).exists():
                    messages.error(request, f'The username "{username}" is already taken.')
                    return redirect('employee_list')
                
                user.username = username
                user.is_active = is_active
                
                # --- MODIFIED: Save the whole name into first_name, clear last_name ---
                user.first_name = full_name
                user.last_name = ''

                if password:
                    user.set_password(password)
                user.save()
                
                if role_name:
                    user.groups.clear()
                    user.groups.add(Group.objects.get(name=role_name))
                
                if branch_id:
                    branch = ClinicBranch.objects.get(branch_id=branch_id)
                    profile, _ = EmployeeProfile.objects.get_or_create(user=user)
                    profile.branch = branch
                    profile.save()

            messages.success(request, f'Employee {username} was successfully updated!')
        except Exception as e:
            messages.error(request, f'An error occurred while updating: {str(e)}')

    return redirect('employee_list')

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def employee_details(request, id):
    return render(request, 'clinic/employee_details.html', {
        'employee': get_object_or_404(User, id=id)
    })


# ─────────────────────────────────────────────
# BRANCH VIEWS (Owner Only)
# ─────────────────────────────────────────────
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def branch_list(request):
    query = request.GET.get('q', '').strip()
    branches = ClinicBranch.objects.filter(branch_location__icontains=query) if query else ClinicBranch.objects.all()
        
    last_branch = ClinicBranch.objects.order_by('branch_id').last()
    next_branch_id = (last_branch.branch_id + 1) if last_branch else 1
        
    return render(request, 'clinic/branch_list.html', {
        'branches': branches,
        'query': query,
        'next_branch_id': next_branch_id,
    })

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def add_branch(request):
    if request.method == 'POST':
        location = request.POST.get('branch_location', '').strip()
        address = request.POST.get('branch_address', '').strip()
        
        if location:
            ClinicBranch.objects.create(branch_location=location, branch_address=address)
            messages.success(request, f'Branch "{location}" was successfully added!')
        else:
            messages.error(request, 'Branch location cannot be empty.')
            
    return redirect('branch_list')

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def update_branch(request, branch_id):
    if request.method == 'POST':
        branch = get_object_or_404(ClinicBranch, branch_id=branch_id)
        new_location = request.POST.get('branch_location', '').strip()
        new_address = request.POST.get('branch_address', '').strip()
        
        if new_location:
            branch.branch_location = new_location
            branch.branch_address = new_address
            branch.save()
            messages.success(request, 'Branch updated successfully!')
        else:
            messages.error(request, 'Branch location cannot be empty.')
            
    return redirect('branch_list')

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def delete_branch(request, branch_id):
    if request.method == 'POST':
        branch = get_object_or_404(ClinicBranch, branch_id=branch_id)
        location_name = branch.branch_location
        branch.delete()
        messages.success(request, f'Branch "{location_name}" was permanently deleted.')
    return redirect('branch_list')

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def branch_details(request, branch_id):
    return render(request, 'clinic/branch_details.html', {
        'branch': get_object_or_404(ClinicBranch, branch_id=branch_id)
    })

# ─────────────────────────────────────────────
# MY PROFILE (For All Authenticated Users)
# ─────────────────────────────────────────────
@login_required(login_url='login')
def my_profile(request):
    user = request.user

    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '').strip()

        try:
            with transaction.atomic():
                # Check if they are trying to change their username to one that exists
                if username and username != user.username:
                    if User.objects.filter(username__iexact=username).exclude(id=user.id).exists():
                        messages.error(request, f'The username "{username}" is already taken.')
                        return redirect('my_profile')
                    user.username = username

                # Update password only if they typed something in the field
                if password:
                    user.set_password(password)

                user.save()

                # Keep the user logged in after a password change!
                if password:
                    update_session_auth_hash(request, user)

                messages.success(request, 'Your profile was successfully updated!')
                return redirect('my_profile')

        except Exception as e:
            messages.error(request, f'An error occurred while updating: {str(e)}')

    # GET request: render the page
    return render(request, 'clinic/my_profile.html', {
        'employee': user
    })