from django.shortcuts import render, redirect, get_object_or_404
from django.db import transaction
from django.db.models import Q
from django.contrib import messages
from datetime import datetime

# Auth and Access Built-ins
from django.contrib.auth.models import User, Group
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth import update_session_auth_hash

# Local Models and Forms
from .models import (
    Patient, Product, Treatment, SalesTransaction, TransactionItem, 
    ClinicBranch, Supplier, EmployeeProfile
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

                # Create the main transaction record
                sale = SalesTransaction.objects.create(
                    patient=patient,
                    total_price_of_products=0, # Will update below
                    total_price_of_treatments=0, # Will update below
                    total_amount=0,
                    mode_of_payment=request.POST.get('mode_of_payment'),
                    notes=notes
                )

                # Process Products
                for pid, qty in zip(product_ids, product_qtys):
                    if pid:
                        product = Product.objects.get(pk=pid)
                        q = int(qty)
                        subtotal = float(product.unit_cost) * q
                        total_products += subtotal
                        TransactionItem.objects.create(
                            transaction=sale, product=product,
                            quantity_purchased=q, subtotal=subtotal
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

                # Update totals on main sale
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
@user_passes_test(is_owner, login_url='login')
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
                with transaction.atomic():
                    sale.transaction_date = transaction_date
                    sale.mode_of_payment = mode_of_payment
                    sale.save()

                    TransactionItem.objects.filter(transaction=sale).delete()

                    total_products, total_treatments = 0.0, 0.0

                    for pid, qty in zip(product_ids, request.POST.getlist('product_qtys')):
                        if pid and qty:
                            product = Product.objects.get(pk=pid)
                            subtotal = float(product.unit_cost) * int(qty)
                            TransactionItem.objects.create(transaction=sale, product=product, quantity_purchased=int(qty), subtotal=subtotal)
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
    products = Product.objects.all()

    if query:
        products = products.filter(
            Q(product_name__icontains=query) |
            Q(product_type__icontains=query)
        )
        
    return render(request, 'clinic/inventory_db.html', {
        'products': products.order_by('product_name'),
        'query': query
    })

@login_required(login_url='login')
def inventory_details(request, product_id):
    product = get_object_or_404(Product, product_id=product_id)
    return render(request, 'clinic/inventory_details.html', {
        'product': product
    })


# ─────────────────────────────────────────────
# PRODUCT VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
def product_add(request):
    suppliers = Supplier.objects.all().order_by('supplier_name')

    if request.method == 'POST':
        errors = []
        name = request.POST.get('product_name', '').strip()
        ptype = request.POST.get('product_type', '').strip()
        cost = request.POST.get('unit_cost', '').strip()
        supplier_id = request.POST.get('supplier', '').strip()

        if not name: errors.append('Product name is required.')
        if not ptype: errors.append('Product type is required.')
        if not supplier_id: errors.append('Please select a supplier.')
        
        if not cost:
            errors.append('Unit cost is required.')
        else:
            try:
                if float(cost) < 0:
                    errors.append('Unit cost cannot be negative.')
            except ValueError:
                errors.append('Unit cost must be a valid number.')

        if not errors and Product.objects.filter(product_name__iexact=name).exists():
            errors.append(f'A product named "{name}" already exists.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return render(request, 'clinic/product_add.html', {'suppliers': suppliers, 'form_data': request.POST})

        Product.objects.create(
            product_name=name,
            product_type=ptype,
            description=request.POST.get('description', '').strip(),
            unit_cost=cost,
            supplier_id=supplier_id,
        )
        messages.success(request, f'Product "{name}" added successfully.')
        return redirect('product_add')

    return render(request, 'clinic/product_add.html', {'suppliers': suppliers, 'form_data': {}})


# ─────────────────────────────────────────────
# SUPPLIER VIEWS
# ─────────────────────────────────────────────
@login_required(login_url='login')
def supplier_db(request):
    query = request.GET.get("q", "").strip()
    suppliers = Supplier.objects.all()

    if query:
        suppliers = suppliers.filter(
            Q(supplier_name__icontains=query) |
            Q(supplier_email__icontains=query)
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


# ─────────────────────────────────────────────
# EMPLOYEE VIEWS (Owner Only)
# ─────────────────────────────────────────────
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def employee_list(request):
    last_user = User.objects.order_by('id').last()
    next_account_id = (last_user.id + 1) if last_user else 1

    return render(request, 'clinic/employee_list.html', {
        'employees': User.objects.all().order_by('username'),
        'groups': Group.objects.all(),
        'branches': ClinicBranch.objects.all(),
        'next_account_id': next_account_id
    })

@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def add_employee(request):
    if request.method == 'POST':
        role_name = request.POST.get('role')
        branch_id = request.POST.get('branch_id')
        username = request.POST.get('username', '').strip()
        is_active = request.POST.get('is_active') == 'True'
        password = request.POST.get('password')

        try:
            with transaction.atomic():
                if User.objects.filter(username__iexact=username).exists():
                    messages.error(request, f'The username "{username}" is already taken.')
                    return redirect('employee_list')

                user = User.objects.create_user(username=username, password=password, is_active=is_active)

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
        
        try:
            with transaction.atomic():
                if User.objects.filter(username__iexact=username).exclude(id=employee_id).exists():
                    messages.error(request, f'The username "{username}" is already taken.')
                    return redirect('employee_list')
                
                user.username = username
                user.is_active = is_active
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