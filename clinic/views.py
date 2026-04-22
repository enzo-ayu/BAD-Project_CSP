# 1. Standard Library Imports
import csv
import io
import json
from datetime import date, datetime, timedelta
from functools import wraps
import re
from django.http import HttpResponse

# 2. Django Core & Third-Party Imports
from django.db.models import Sum, Count, F
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout, update_session_auth_hash
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User, Group
from django.db import models, transaction
from django.db.models import Q
from django.http import JsonResponse
from django.http import HttpResponseForbidden
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.utils import timezone
from django.views.decorators.cache import never_cache

# 3. Local Application Imports (Models and Forms)
from .models import (
    BranchProduct,
    BranchTreatment,
    ClinicBranch,
    EmployeeProfile,
    InventoryShipment,
    Patient,
    Product,
    ReceivedProduct,
    SalesTransaction,
    Supplier,
    TransactionItem,
    Treatment,
    UserLockout
)
from .forms import RoleBasedRegistrationForm

# ─────────────────────────────────────────────
# HELPER FUNCTIONS
# ─────────────────────────────────────────────
def is_owner(user):
    return user.groups.filter(name='Owner').exists()

def is_aesthetician(user):
    return user.groups.filter(name='Aesthetician').exists()

def is_sales(user):
    return user.groups.filter(name='Sales').exists()

def role_required(allowed_roles=[]):
    def decorator(view_func):
        
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            # 1. Check if they have the right role
            if request.user.groups.filter(name__in=allowed_roles).exists():
                return view_func(request, *args, **kwargs)
            
            # 2. If they are logged in but WRONG role, don't send them to login! 
            if request.user.is_authenticated:
                return HttpResponseForbidden("<h1>403 Forbidden</h1><p>You do not have the correct role to view this page.</p><a href='/'>Go back</a>")
            
            # 3. If they are NOT logged in, send them to login
            messages.error(request, "Please log in to access this page.")
            return redirect('login')  
        return wrapper
    return decorator

def get_user_branch(request):
    try:
        profile = request.user.employeeprofile
        if is_owner(request.user):
            branch_id = request.session.get('selected_branch')
            if branch_id:
                try:
                    return ClinicBranch.objects.filter(pk=int(branch_id)).first()
                except (ValueError, TypeError):
                    return None
            return None  # All branches
        return profile.branch or ClinicBranch.objects.first()
    except:
        return ClinicBranch.objects.first()
        
# ─────────────────────────────────────────────
#  NAVBAR (for owner)
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def set_branch_session(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
        except (json.JSONDecodeError, ValueError):
            data = request.POST

        branch_id = data.get('branch_id', '')
        if branch_id:
            request.session['selected_branch'] = str(branch_id)
        else:
            request.session.pop('selected_branch', None)

        return JsonResponse({'status': 'ok'})
    return JsonResponse({'status': 'error'}, status=400)


def custom_login_view(request):
    # ─── 0. REDIRECT IF ALREADY LOGGED IN ───
    if request.user.is_authenticated:
        if is_owner(request.user) or is_sales(request.user):
            return redirect('sales_db')
        elif is_aesthetician(request.user):
            return redirect('patient_db') 
        else:
            # THIS BREAKS THE LOOP
            return HttpResponseForbidden("<h1>403 Forbidden</h1><p>Your account has no roles assigned. Please ask an admin to assign you to a group (Owner, Sales, or Aesthetician).</p><a href='/logout/'>Click here to logout</a>")

    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        # ─── 1. BROWSER LOCKOUT CHECK ───
        lock_until_ts = request.session.get('lock_until')
        if lock_until_ts and timezone.now().timestamp() < lock_until_ts:
            return render(request, 'clinic/login.html', {
                'error': 'Account locked due to too many failed attempts (Browser). Please try again in 1 minute.'
            })

        # ─── 2. DATABASE LOCKOUT CHECK ───
        try:
            user = User.objects.get(username=username)
            lockout, created = UserLockout.objects.get_or_create(user=user)
            if lockout.lock_until and lockout.lock_until > timezone.now():
                return render(request, 'clinic/login.html', {
                    'error': 'Account locked due to too many failed attempts (Account). Please try again in 1 minute.'
                })
        except User.DoesNotExist:
            user = None
            lockout = None

        # ─── 3. AUTHENTICATION ───
        print(f"DEBUG: Attempting login for username: {username}")
        auth_user = authenticate(request, username=username, password=password)

        if auth_user is not None:
            print("DEBUG: Authentication successful!")
            # Reset everything on success
            request.session['failed_attempts'] = 0
            request.session['lock_until'] = None
            
            if lockout:
                lockout.failed_attempts = 0
                lockout.lock_until = None
                lockout.save()
            
            # CRITICAL: This is the part that actually logs you in!
            login(request, auth_user)
            
            # ---> NEW REDIRECT LOGIC HERE TOO <---
            if is_owner(request.user) or is_sales(request.user):
                return redirect('sales_db')
            elif is_aesthetician(request.user):
                return redirect('patient_db') 
            else:
                # THIS BREAKS THE LOOP
                return HttpResponseForbidden("<h1>403 Forbidden</h1><p>Your account has no roles assigned. Please ask an admin to assign you to a group (Owner, Sales, or Aesthetician).</p><a href='/logout/'>Click here to logout</a>")
            
        else:
            # ─── 4. FAILED ATTEMPT LOGIC ───
            exists = User.objects.filter(username=username).exists()
            print(f"DEBUG: Authentication failed. User exists in DB? {exists}")
            
            failed_attempts = request.session.get('failed_attempts', 0) + 1
            request.session['failed_attempts'] = failed_attempts
            
            if failed_attempts >= 4:
                lock_time = timezone.now() + timedelta(minutes=1)
                request.session['lock_until'] = lock_time.timestamp()
                
                if lockout:
                    lockout.failed_attempts = failed_attempts
                    lockout.lock_until = lock_time
                    lockout.save()

                return render(request, 'clinic/login.html', {
                    'error': 'Account locked due to too many failed attempts. Please try again in 1 minute.'
                })

            if lockout:
                lockout.failed_attempts = failed_attempts
                lockout.save()

            attempts_left = 4 - failed_attempts
            error_message = f'Invalid username or password. You have {attempts_left} attempt(s) remaining.'
            return render(request, 'clinic/login.html', {'error': error_message})

    # ─── 5. DEFAULT GET REQUEST ───
    return render(request, 'clinic/login.html')

def custom_logout_view(request):
    # This logs the user out and clears their session
    logout(request) 
    # This sends them back to your custom login page
    return redirect('login')
# ─────────────────────────────────────────────
# CHARGESLIP (Create New Sale)
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def chargeslip(request):
    if request.method == 'POST':
        errors = []
        is_new_patient = request.POST.get('is_new_patient') == 'true'
        notes = request.POST.get('notes', '').strip()

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

        if not request.POST.get('mode_of_payment', '').strip():
            errors.append('Please select a mode of payment.')

        product_ids = [p for p in request.POST.getlist('actual_product_ids') if p]
        treatment_ids = [t for t in request.POST.getlist('actual_treatment_ids') if t]

        if not product_ids and not treatment_ids:
            errors.append('Please add at least one product or treatment.')

        for qty in request.POST.getlist('product_qtys') + request.POST.getlist('treatment_qtys'):
            try:
                if int(qty) < 1:
                    errors.append('All quantities must be at least 1.')
                    break
            except (ValueError, TypeError):
                errors.append('Invalid quantity entered.')
                break

        if errors:
            for error in errors:
                messages.error(request, error)

            # ── Rebuild submitted state to re-hydrate the form ──
            product_qtys = request.POST.getlist('product_qtys')
            treatment_qtys = request.POST.getlist('treatment_qtys')

            submitted_products = [
                {'id': pid, 'qty': qty}
                for pid, qty in zip(product_ids, product_qtys)
                if pid
            ]
            submitted_treatments = [
                {'id': tid, 'qty': qty}
                for tid, qty in zip(treatment_ids, treatment_qtys)
                if tid
            ]

            # Preserve patient field values
            submitted_patient = {
                'is_new': is_new_patient,
                'patient_id': request.POST.get('patient', ''),
                'last_name': request.POST.get('last_name', ''),
                'first_name': request.POST.get('first_name', ''),
                'middle_name': request.POST.get('middle_name', ''),
                'suffix': request.POST.get('suffix', ''),
                'address': request.POST.get('address', ''),
                'contact': request.POST.get('contact', ''),
                'birthday': request.POST.get('birthday', ''),
                'sex': request.POST.get('sex', ''),
            }

            return render(request, 'clinic/chargeslip.html', {
                'patients': Patient.objects.filter(is_deleted=False).order_by('last_name'),
                'products': Product.objects.filter(is_deleted=False).order_by('product_type', 'product_name'),
                'treatments': Treatment.objects.filter(is_deleted=False).order_by('treatment_type', 'treatment_name'),
                'submitted_products': json.dumps(submitted_products),
                'submitted_treatments': json.dumps(submitted_treatments),
                'submitted_patient': json.dumps(submitted_patient),
                'mode_of_payment': request.POST.get('mode_of_payment', ''),
                'notes': notes,
            })

        # ─────────────────────────────────────────
        # SAVE LOGIC
        # ─────────────────────────────────────────
        try:
            employee_branch = get_user_branch(request)
            if not employee_branch:
                raise Exception("No branch available. Please contact the owner.")

            with transaction.atomic():

                # ── Patient Handling ──
                if is_new_patient:
                    last = request.POST.get('last_name').strip()
                    first = request.POST.get('first_name').strip()
                    middle = request.POST.get('middle_name', '').strip()
                    bday = request.POST.get('birthday').strip()

                    if Patient.objects.filter(
                        last_name__iexact=last,
                        first_name__iexact=first,
                        middle_name__iexact=middle,
                        birthday=bday
                    ).exists():
                        # Re-hydrate form with duplicate patient error
                        product_qtys = request.POST.getlist('product_qtys')
                        treatment_qtys = request.POST.getlist('treatment_qtys')
                        submitted_patient = {
                            'is_new': is_new_patient,
                            'patient_id': '',
                            'last_name': last,
                            'first_name': first,
                            'middle_name': middle,
                            'suffix': request.POST.get('suffix', '').strip(),
                            'address': request.POST.get('address', '').strip(),
                            'contact': request.POST.get('contact', '').strip(),
                            'birthday': bday,
                            'sex': request.POST.get('sex', ''),
                        }
                        messages.error(
                            request,
                            f'A patient named {first} {middle} {last} with the same birthday already exists.'
                        )
                        return render(request, 'clinic/chargeslip.html', {
                            'patients': Patient.objects.filter(is_deleted=False).order_by('last_name'),
                            'products': Product.objects.filter(is_deleted=False).order_by('product_type', 'product_name'),
                            'treatments': Treatment.objects.filter(is_deleted=False).order_by('treatment_type', 'treatment_name'),
                            'submitted_products': json.dumps([
                                {'id': pid, 'qty': qty}
                                for pid, qty in zip(product_ids, product_qtys) if pid
                            ]),
                            'submitted_treatments': json.dumps([
                                {'id': tid, 'qty': qty}
                                for tid, qty in zip(treatment_ids, treatment_qtys) if tid
                            ]),
                            'submitted_patient': json.dumps(submitted_patient),
                            'mode_of_payment': request.POST.get('mode_of_payment', ''),
                            'notes': notes,
                        })

                    patient = Patient.objects.create(
                        last_name=last,
                        first_name=first,
                        middle_name=middle,
                        suffix=request.POST.get('suffix', '').strip() or "",
                        patient_contact_number=request.POST.get('contact', '').strip(),
                        patient_address=request.POST.get('address', '').strip(),
                        birthday=bday,
                        sex=request.POST.get('sex'),
                    )
                else:
                    patient = Patient.objects.get(pk=request.POST.get('patient'), is_deleted=False)

                # ── Initialize Totals ──
                total_products = 0.0
                total_treatments = 0.0

                product_qtys = request.POST.getlist('product_qtys')
                treatment_qtys = request.POST.getlist('treatment_qtys')

                # ── Create Sale ──
                sale = SalesTransaction.objects.create(
                    patient=patient,
                    branch=employee_branch,
                    total_price_of_products=0,
                    total_price_of_treatments=0,
                    total_amount=0,
                    mode_of_payment=request.POST.get('mode_of_payment'),
                    notes=notes
                )

                # ── Process Products ──
                for pid, qty in zip(product_ids, product_qtys):
                    if pid:
                        product = Product.objects.get(pk=pid)
                        q = int(qty)

                        branch_product = BranchProduct.objects.filter(
                            product=product,
                            branch=employee_branch
                        ).first()

                        if not branch_product or branch_product.stock_quantity < q:
                            available = branch_product.stock_quantity if branch_product else 0
                            raise Exception(
                                f"Not enough stock for {product.product_name}. Available: {available}"
                            )

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

                # ── Process Treatments ──
                for tid, qty in zip(treatment_ids, treatment_qtys):
                    if tid:
                        treatment = Treatment.objects.get(pk=tid)
                        q = int(qty)

                        subtotal = float(treatment.treatment_cost) * q
                        total_treatments += subtotal

                        TransactionItem.objects.create(
                            transaction=sale,
                            treatment=treatment,
                            quantity_purchased=q,
                            subtotal=subtotal
                        )

                # ── Final Totals ──
                sale.total_price_of_products = total_products
                sale.total_price_of_treatments = total_treatments
                sale.total_amount = total_products + total_treatments
                sale.save()

            messages.success(request, 'Chargeslip saved successfully.')
            return redirect('sales_db')

        except Exception as e:
            # Re-hydrate the form with all submitted data so nothing is lost
            product_qtys = request.POST.getlist('product_qtys')
            treatment_qtys = request.POST.getlist('treatment_qtys')
            submitted_patient = {
                'is_new': is_new_patient,
                'patient_id': request.POST.get('patient', ''),
                'last_name': request.POST.get('last_name', ''),
                'first_name': request.POST.get('first_name', ''),
                'middle_name': request.POST.get('middle_name', ''),
                'suffix': request.POST.get('suffix', ''),
                'address': request.POST.get('address', ''),
                'contact': request.POST.get('contact', ''),
                'birthday': request.POST.get('birthday', ''),
                'sex': request.POST.get('sex', ''),
            }
            messages.error(request, f'An error occurred while saving: {str(e)}')
            return render(request, 'clinic/chargeslip.html', {
                'patients': Patient.objects.filter(is_deleted=False).order_by('last_name'),
                'products': Product.objects.filter(is_deleted=False).order_by('product_type', 'product_name'),
                'treatments': Treatment.objects.filter(is_deleted=False).order_by('treatment_type', 'treatment_name'),
                'submitted_products': json.dumps([
                    {'id': pid, 'qty': qty}
                    for pid, qty in zip(product_ids, product_qtys) if pid
                ]),
                'submitted_treatments': json.dumps([
                    {'id': tid, 'qty': qty}
                    for tid, qty in zip(treatment_ids, treatment_qtys) if tid
                ]),
                'submitted_patient': json.dumps(submitted_patient),
                'mode_of_payment': request.POST.get('mode_of_payment', ''),
                'notes': notes,
            })

    # ── GET Request ──
    return render(request, 'clinic/chargeslip.html', {
        'patients': Patient.objects.filter(is_deleted=False).order_by('last_name'),
        'products': Product.objects.filter(is_deleted=False).order_by('product_type', 'product_name'),
        'treatments': Treatment.objects.filter(is_deleted=False).order_by('treatment_type', 'treatment_name'),
    })

# ─────────────────────────────────────────────
# PATIENT VIEWS
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician']) 
def patient_db(request):
    query = request.GET.get("q", "").strip()
    patients = Patient.objects.filter(is_deleted=False)
    
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
        "user_is_owner": is_owner(request.user),
        "user_is_aesthetician": is_aesthetician(request.user),
    })

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician']) 
def patient_details(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)

    transactions = SalesTransaction.objects.filter(
        patient=patient
    ).order_by('-transaction_date')
    
    all_notes = transactions.exclude(notes__isnull=True)\
                            .exclude(notes__exact='')\
                            .values('notes', 'transaction_date', 'transaction_id')

    return render(request, 'clinic/patient_details.html', {
        'patient': patient,
        'transactions': transactions,
        'all_notes': all_notes,
    })

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician']) 
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
        middle = request.POST.get('middle_name', '').strip()
        birthday = request.POST.get('birthday', '').strip()

        if not errors and Patient.objects.filter(
            last_name__iexact=last, 
            first_name__iexact=first, 
            middle_name__iexact=middle,
            birthday=birthday
        ).exists():
            errors.append(f'A patient named {first} {middle} {last} with the same birthday already exists.')

        if errors:
            for error in errors:
                messages.error(request, error)
            return redirect('patient_db')

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

    return redirect('patient_db')

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def patient_update(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)

    if request.method != 'POST':
        return redirect('patient_db')

    is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'

    required_fields = {
        'last_name': 'Last Name', 'first_name': 'First Name',
        'patient_address': 'Address', 'patient_contact_number': 'Contact Number',
        'birthday': 'Birthday', 'sex': 'Sex'
    }

    errors = [
        f'{label} is required.'
        for field, label in required_fields.items()
        if not request.POST.get(field, '').strip()
    ]

    last = request.POST.get('last_name', '').strip()
    first = request.POST.get('first_name', '').strip()
    middle = request.POST.get('middle_name', '').strip()
    birthday = request.POST.get('birthday', '').strip()

    if not errors and Patient.objects.filter(
        last_name__iexact=last,
        first_name__iexact=first,
        middle_name__iexact=middle,
        birthday=birthday
    ).exclude(patient_id=patient_id).exists():
        errors.append(f'A patient named {first} {middle} {last} with the same birthday already exists.')

    if errors:
        if is_ajax:
            return JsonResponse({'success': False, 'errors': errors})
        for error in errors:
            messages.error(request, error)
        return redirect('patient_db')

    patient.last_name = last
    patient.first_name = first
    patient.middle_name = middle
    patient.suffix = request.POST.get('suffix', '').strip() or ""
    patient.patient_address = request.POST.get('patient_address', '').strip()
    patient.patient_contact_number = request.POST.get('patient_contact_number', '').strip()
    patient.birthday = birthday
    patient.sex = request.POST.get('sex', '').strip()
    patient.save()

    if is_ajax:
        return JsonResponse({'success': True, 'message': f'Patient {patient.first_name} {patient.last_name} updated successfully.'})

    messages.success(request, f'Patient {patient.first_name} {patient.last_name} updated successfully.')
    return redirect('patient_db')

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician']) 
def patient_delete(request, patient_id):
    patient = get_object_or_404(Patient, patient_id=patient_id)
    if request.method == 'POST':
        name = f'{patient.first_name} {patient.last_name}'
        patient.is_deleted = True
        patient.save()
        messages.success(request, f'Patient {name} has been deleted.')
        return redirect('patient_db')
    return redirect('patient_update', patient_id=patient_id)

# ─────────────────────────────────────────────
# SALES & CHARGESLIP VIEWS
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales']) 
def sales_db(request):
    query = request.GET.get("q", "").strip()
    date_filter = request.GET.get("date", "").strip()
    sales = SalesTransaction.objects.all().select_related("patient", "branch")

    branch = get_user_branch(request)
    if branch:
        sales = sales.filter(branch=branch)

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
        "sales": sales.order_by("-transaction_date", "-transaction_id"),
        "query": query,
        "date_filter": date_filter,
        "user_is_owner": is_owner(request.user),
        "all_products": Product.objects.all().order_by('product_type', 'product_name'),
        "all_treatments": Treatment.objects.all().order_by('treatment_type', 'treatment_name'),
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
        'branch': sale.branch,
        'notes': sale.notes,
    }

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician']) 
def view_chargeslip_patient(request, transaction_id):
    return render(request, 'clinic/chargeslip_view.html', _get_chargeslip_context(transaction_id))

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician']) 
def view_chargeslip_sales(request, transaction_id):
    return render(request, 'clinic/chargeslip_view_sales.html', _get_chargeslip_context(transaction_id))

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
def sales_update(request, transaction_id):
    sale = get_object_or_404(SalesTransaction, transaction_id=transaction_id)

    if not is_owner(request.user):
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({'success': False, 'errors': ['You are not authorized to access this page.']})
        messages.error(request, "You are not authorized to access this page.")
        referer = request.META.get('HTTP_REFERER')
        return redirect(referer if referer else 'sales_db')

    if request.method != 'POST':
        return redirect('sales_db')

    is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'

    errors = []
    transaction_date = request.POST.get('transaction_date', '').strip()
    mode_of_payment = request.POST.get('mode_of_payment', '').strip()
    product_ids = [p for p in request.POST.getlist('product_ids') if p]
    treatment_ids = [t for t in request.POST.getlist('treatment_ids') if t]
    product_qtys = request.POST.getlist('product_qtys')
    treatment_qtys = request.POST.getlist('treatment_qtys')

    if not transaction_date:
        errors.append('Transaction date is required.')
    if not mode_of_payment:
        errors.append('Mode of payment is required.')
    if not product_ids and not treatment_ids:
        errors.append('Please add at least one product or treatment.')

    for qty in product_qtys + treatment_qtys:
        try:
            if int(qty) < 1:
                errors.append('Invalid Quantity Value: quantities must be at least 1.')
                break
        except (ValueError, TypeError):
            errors.append('Invalid Quantity Value: please enter a valid number.')
            break

    if errors:
        if is_ajax:
            return JsonResponse({'success': False, 'errors': errors})
        for error in errors:
            messages.error(request, error)
        request.session['reopen_sale_modal'] = str(transaction_id)
        return redirect('sales_db')

    try:
        from .models import BranchProduct

        employee_branch = sale.branch
        if not employee_branch:
            raise Exception("This sale has no branch assigned.")

        with transaction.atomic():
            sale.transaction_date = transaction_date
            sale.mode_of_payment = mode_of_payment
            sale.save()

            old_items = TransactionItem.objects.filter(transaction=sale).select_related('product')
            for item in old_items:
                if item.product:
                    bp = BranchProduct.objects.filter(
                        product=item.product,
                        branch=employee_branch
                    ).first()
                    if bp:
                        bp.stock_quantity += item.quantity_purchased
                        bp.save()

            TransactionItem.objects.filter(transaction=sale).delete()

            total_products = 0.0
            total_treatments = 0.0
            product_qtys = request.POST.getlist('product_qtys')
            treatment_qtys = request.POST.getlist('treatment_qtys')

            for pid, qty in zip(product_ids, product_qtys):
                if pid and qty:
                    product = Product.objects.get(pk=pid)
                    q = int(qty)
                    bp = BranchProduct.objects.filter(
                        product=product,
                        branch=employee_branch
                    ).first()
                    if not bp or bp.stock_quantity < q:
                        available = bp.stock_quantity if bp else 0
                        raise Exception(
                            f"Not enough stock for {product.product_name}. Available: {available}"
                        )
                    bp.stock_quantity -= q
                    bp.save()
                    subtotal = float(product.unit_cost) * q
                    total_products += subtotal
                    TransactionItem.objects.create(
                        transaction=sale,
                        product=product,
                        quantity_purchased=q,
                        subtotal=subtotal
                    )

            for tid, qty in zip(treatment_ids, treatment_qtys):
                if tid and qty:
                    treatment = Treatment.objects.get(pk=tid)
                    q = int(qty)
                    subtotal = float(treatment.treatment_cost) * q
                    total_treatments += subtotal
                    TransactionItem.objects.create(
                        transaction=sale,
                        treatment=treatment,
                        quantity_purchased=q,
                        subtotal=subtotal
                    )

            sale.total_price_of_products = total_products
            sale.total_price_of_treatments = total_treatments
            sale.total_amount = total_products + total_treatments
            sale.save()

        if is_ajax:
            return JsonResponse({'success': True, 'message': f'Sale #{sale.transaction_id} updated successfully.'})

        messages.success(request, f'Sale #{sale.transaction_id} updated successfully.')

    except Exception as e:
        if is_ajax:
            return JsonResponse({'success': False, 'errors': [f'An error occurred while saving: {str(e)}']})
        messages.error(request, f'An error occurred while saving: {str(e)}')
        request.session['reopen_sale_modal'] = str(transaction_id)

    return redirect('sales_db')

@login_required(login_url='login')
def clear_reopen_session(request):
    if request.method == 'POST':
        request.session.pop('reopen_sale_modal', None)
    return JsonResponse({'status': 'ok'}) 
    
@never_cache
@login_required(login_url='login')
@role_required(['Owner']) 
def sales_delete(request, transaction_id):
    sale = get_object_or_404(SalesTransaction, transaction_id=transaction_id)
    if request.method == 'POST':
        from .models import BranchProduct
        try:
            employee_branch = get_user_branch(request)
        except:
            employee_branch = ClinicBranch.objects.first()

        with transaction.atomic():
            items = TransactionItem.objects.filter(transaction=sale).select_related('product')
            for item in items:
                if item.product:
                    if employee_branch:
                        bp = BranchProduct.objects.filter(
                            product=item.product,
                            branch=employee_branch
                        ).first()
                    else:
                        bp = BranchProduct.objects.filter(
                            product=product
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
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
def inventory_db(request):
    query = request.GET.get("q", "").strip()
    date_filter = request.GET.get("date", "").strip()

    branch = get_user_branch(request)  
    shipments = InventoryShipment.objects.select_related(
        'supplier', 'branch'
    ).prefetch_related('received_products__product')

    if branch:
        shipments = shipments.filter(branch=branch)

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
        'products': Product.objects.filter(is_deleted=False).order_by('product_name'),
        'suppliers': Supplier.objects.filter(is_deleted=False).order_by('supplier_name'),
        'branches': ClinicBranch.objects.all().order_by('branch_location'),
        'query': query,
        'date_filter': date_filter,
        'user_is_owner': is_owner(request.user),
        'user_branch': branch,
    })

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def inventory_add(request):
    if request.method == 'POST':
        try:
            from .models import BranchProduct
            product_id = request.POST.get('product')
            product = Product.objects.get(pk=product_id, is_deleted=False)
            quantity_received = int(request.POST.get('quantity_received'))
            if quantity_received < 1:
                raise Exception("Quantity received must be at least 1.")
            if quantity_received > 10000:
                raise Exception("Quantity received cannot exceed 10,000.")
                

            date_received = request.POST.get('date_received')
            expiration_date = request.POST.get('expiration_date')
            if expiration_date and date_received and expiration_date <= date_received:
                raise Exception("Expiration date must be after the date received.")

            # Use logged-in user's branch if no branch posted (non-owner)
            branch_id = request.POST.get('branch') or None
            if not branch_id:
                user_branch = get_user_branch(request)
                if not user_branch:
                    raise Exception("No branch assigned. Please contact the owner.")
                branch_id = user_branch.branch_id

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

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def inventory_update(request, record_id):
    if request.method == 'POST':
        from .models import BranchProduct

        shipment = get_object_or_404(InventoryShipment, pk=record_id)

        # Non-owners can only edit shipments from their own branch
        if not is_owner(request.user):
            user_branch = get_user_branch(request)
            if user_branch and shipment.branch != user_branch:
                messages.error(request, "You are not authorized to edit this shipment.")
                return redirect('inventory_db')

        try:
            product_id = request.POST.get('product')
            product = Product.objects.get(pk=product_id, is_deleted=False)
            new_qty = int(request.POST.get('quantity_received'))
            if new_qty < 1:
                raise Exception("Quantity received must be at least 1.")
            if new_qty > 10000:
                raise Exception("Quantity received cannot exceed 10,000.")

            date_received = request.POST.get('date_received')
            expiration_date = request.POST.get('expiration_date')
            if expiration_date and date_received and expiration_date <= date_received:
                raise Exception("Expiration date must be after the date received.")

            # Use posted branch for owners, user's branch for aestheticians
            new_branch_id = request.POST.get('branch') or None
            if not new_branch_id:
                user_branch = get_user_branch(request)
                if not user_branch:
                    raise Exception("No branch assigned. Please contact the owner.")
                new_branch_id = user_branch.branch_id

            with transaction.atomic():
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

                shipment.received_product_name = product.product_name
                shipment.date_received = request.POST.get('date_received')
                shipment.supplier_id = request.POST.get('supplier')
                shipment.branch_id = new_branch_id
                shipment.save()

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

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])  
def inventory_delete(request, record_id):
    if not is_owner(request.user):
        messages.error(request, "You are not authorized to access this page.")
        referer = request.META.get('HTTP_REFERER')
        return redirect(referer if referer else 'inventory_db')

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

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
def inventory_details(request, record_id):
    branch = get_user_branch(request)

    queryset = InventoryShipment.objects.select_related(
        'supplier', 'branch'
    ).prefetch_related(
        'received_products__product'
    )

    if branch:
        queryset = queryset.filter(branch=branch)

    shipment = get_object_or_404(queryset, pk=record_id)

    return render(request, 'clinic/inventory_details.html', {
        'shipment': shipment,
        'received_products': shipment.received_products.all(),
    })
# ─────────────────────────────────────────────
# PRODUCT TREATMENT
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
def producttreatment_db(request):

    product_query = request.GET.get("product_q", "").strip()
    treatment_query = request.GET.get("treatment_q", "").strip()
    product_sort = request.GET.get("product_sort", "")
    treatment_sort = request.GET.get("treatment_sort", "")
    product_type = request.GET.get("product_type", "")
    treatment_type = request.GET.get("treatment_type", "")

    # ── Determine branch first ──
    if is_owner(request.user):
        selected_branch = request.session.get('selected_branch')
        if selected_branch == 'all' or not selected_branch:
            branch = None
        else:
            branch = ClinicBranch.objects.filter(pk=selected_branch).first()
    else:
        branch = get_user_branch(request)

    # ── Now filter products/treatments by branch ──
    products = Product.objects.filter(is_deleted=False)
    treatments = Treatment.objects.filter(is_deleted=False)

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
    if product_type:
        products = products.filter(product_type=product_type)
    if treatment_type:
        treatments = treatments.filter(treatment_type=treatment_type)

    # PRODUCTS
    if product_sort == "price_desc":
        products = products.order_by('-unit_cost')
    elif product_sort == "price_asc":
        products = products.order_by('unit_cost')
    elif product_sort == "name_desc":
        products = products.order_by('-product_name')
    else:
        products = products.order_by('product_name')

    # TREATMENTS
    if treatment_sort == "price_desc":
        treatments = treatments.order_by('-treatment_cost')
    elif treatment_sort == "price_asc":
        treatments = treatments.order_by('treatment_cost')
    elif treatment_sort == "name_desc":
        treatments = treatments.order_by('-treatment_name')
    else:
        treatments = treatments.order_by('treatment_name')

    product_types = Product.objects.filter(is_deleted=False).values_list('product_type', flat=True).distinct()
    treatment_types = Treatment.objects.filter(is_deleted=False).values_list('treatment_type', flat=True).distinct()

    # ── Stock map ──
    if branch:
        branch_stock = BranchProduct.objects.filter(
            branch=branch
        ).values('product_id', 'stock_quantity', 'quantity_minimum', 'branch_id')
        stock_map = {bp['product_id']: bp for bp in branch_stock}
    else:
        from django.db.models import Sum
        branch_stock = BranchProduct.objects.values('product_id').annotate(
            stock_quantity=Sum('stock_quantity'),
            quantity_minimum=Sum('quantity_minimum')
        )
        stock_map = {bp['product_id']: bp for bp in branch_stock}

    for product in products:
        bp = stock_map.get(product.product_id)
        product.branch_stock    = bp['stock_quantity'] if bp else 0
        product.branch_minimum  = bp['quantity_minimum'] if bp else 0
        product.branch_id_val = bp.get('branch_id') if (bp and 'branch_id' in bp) else None
        product.branch_location_val = branch.branch_location if branch else ''
        product.is_out_of_stock = product.branch_stock == 0
        product.is_low_stock    = product.branch_stock <= product.branch_minimum

    # ── Treatment availability ──
    if branch:
        available_treatment_ids = set(
            BranchTreatment.objects.filter(
                branch=branch,
                availability_status=True
            ).values_list('treatment_id', flat=True)
        )
    else:
        available_treatment_ids = set(
            BranchTreatment.objects.filter(
                availability_status=True
            ).values_list('treatment_id', flat=True)
        )

    for treatment in treatments:
        treatment.is_unavailable = treatment.treatment_id not in available_treatment_ids

    return render(request, 'clinic/producttreatment_db.html', {
        'products': products,
        'treatments': treatments,
        'product_query': product_query,
        'treatment_query': treatment_query,
        'product_sort': product_sort,
        'treatment_sort': treatment_sort,
        'product_type': product_type,
        'treatment_type': treatment_type,
        'product_types': product_types,
        'treatment_types': treatment_types,
        'branch': branch,
        'suppliers': Supplier.objects.filter(is_deleted=False).order_by('supplier_name'),
        'branches': ClinicBranch.objects.all().order_by('branch_location'),
        'user_is_owner': is_owner(request.user),
    })

MAX_NAME_LENGTH = 100
MAX_COST = 999999.99
# ─────────────────────────────────────────────
# PRODUCT VIEWS
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner'])
def product_add(request):
    if not is_owner(request.user):
        messages.error(request, "You are not authorized to access this page.")
        referer = request.META.get('HTTP_REFERER')
        return redirect(referer if referer else 'producttreatment_db')

    if request.method == 'POST':
        name        = request.POST.get('product_name', '').strip()
        ptype       = request.POST.get('product_type', '').strip()
        desc        = request.POST.get('description', '').strip()
        cost        = request.POST.get('unit_cost', '').strip()
        stock       = request.POST.get('stock_quantity', '').strip()
        min_qty     = request.POST.get('quantity_minimum', '').strip()
        supplier_id = request.POST.get('supplier')
        branch_ids  = request.POST.getlist('branch')

        if not all([name, ptype, cost, supplier_id, branch_ids]):
            messages.error(request, 'All fields are required.')
            return redirect('producttreatment_db')

        # Duplicate name check
        if Product.objects.filter(product_name__iexact=name, is_deleted=False).exists():
            return JsonResponse({'error': f'A product named "{name}" already exists.'}, status=400)

        # Max length check
        if len(name) > MAX_NAME_LENGTH:
            messages.error(request, f'Product name must not exceed {MAX_NAME_LENGTH} characters.')
            return redirect('producttreatment_db')

        # Cost upper bound check
        try:
            cost_val = float(cost)
        except ValueError:
            messages.error(request, 'Invalid unit cost value.')
            return redirect('producttreatment_db')

        if cost_val <= 0:
            messages.error(request, 'Unit cost cannot be negative.')
            return redirect('producttreatment_db')

        if cost_val > MAX_COST:
            messages.error(request, f'Unit cost cannot exceed {MAX_COST:,.2f}.')
            return redirect('producttreatment_db')

        # Min quantity check
        try:
            min_qty_val = int(min_qty)
        except ValueError:
            messages.error(request, 'Invalid quantity minimum value.')
            return redirect('producttreatment_db')

        if min_qty_val < 1:
            messages.error(request, 'Quantity minimum must be at least 1.')
            return redirect('producttreatment_db')

        try:
            stock_val = int(stock)
        except ValueError:
            messages.error(request, 'Invalid stock quantity value.')
            return redirect('producttreatment_db')

        if stock_val < 1:
            messages.error(request, 'Stock quantity must be at least 1.')
            return redirect('producttreatment_db')

        try:
            with transaction.atomic():
                product = Product.objects.create(
                    product_name=name,
                    product_type=ptype,
                    unit_cost=cost_val,
                    description=desc,
                    supplier_id=supplier_id,
                )
                for bid in branch_ids:
                    BranchProduct.objects.create(
                        product=product,
                        branch_id=bid,
                        stock_quantity=stock_val,
                        quantity_minimum=min_qty_val,
                    )
            messages.success(request, f'Product "{name}" added successfully.')
            if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                return JsonResponse({'success': True})
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')

    return redirect('producttreatment_db')

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def product_update(request, product_id):
    product = get_object_or_404(Product, product_id=product_id, is_deleted=False)

    if is_owner(request.user):
        branch = get_user_branch(request)
        if not branch:
            messages.error(request, "Please select a specific branch from the navbar before updating products.")
            return redirect('producttreatment_db')
    else:
        try:
            branch = request.user.employeeprofile.branch
        except:
            branch = None
        if not branch:
            messages.error(request, "No branch assigned to your account. Please contact the owner.")
            return redirect('producttreatment_db')

    if request.method == 'POST':
        name        = request.POST.get('product_name', '').strip()
        ptype       = request.POST.get('product_type', '').strip()
        desc        = request.POST.get('description', '').strip()
        cost        = request.POST.get('unit_cost', '').strip()
        min_qty     = request.POST.get('quantity_minimum', '').strip()
        supplier_id = request.POST.get('supplier')

        if not all([name, ptype, desc, cost, min_qty, supplier_id]):
            messages.error(request, "All fields are required.")
            return redirect('producttreatment_db')

        # Duplicate name check (exclude current product)
        if Product.objects.filter(product_name__iexact=name, is_deleted=False).exclude(product_id=product_id).exists():
            return JsonResponse({'error': f'A product named "{name}" already exists.'}, status=400)

        # Max length check
        if len(name) > MAX_NAME_LENGTH:
            messages.error(request, f'Product name must not exceed {MAX_NAME_LENGTH} characters.')
            return redirect('producttreatment_db')

        # Cost validation
        try:
            cost_val = float(cost)
        except ValueError:
            messages.error(request, 'Invalid unit cost value.')
            return redirect('producttreatment_db')

        if cost_val <= 0:
            messages.error(request, 'Unit cost cannot be negative.')
            return redirect('producttreatment_db')

        if cost_val > MAX_COST:
            messages.error(request, f'Unit cost cannot exceed {MAX_COST:,.2f}.')
            return redirect('producttreatment_db')

        # Min quantity check
        try:
            min_qty_val = int(min_qty)
        except ValueError:
            messages.error(request, 'Invalid quantity minimum value.')
            return redirect('producttreatment_db')

        if min_qty_val < 1:
            messages.error(request, 'Quantity minimum must be at least 1.')
            return redirect('producttreatment_db')

        try:
            product.product_name = name
            product.product_type = ptype
            product.description  = desc
            product.unit_cost    = cost_val
            product.supplier_id  = supplier_id
            product.save()

            branch_product, created = BranchProduct.objects.get_or_create(
                product=product,
                branch=branch,
                defaults={'stock_quantity': 0, 'quantity_minimum': min_qty_val}
            )
            if not created:
                branch_product.quantity_minimum = min_qty_val
                branch_product.save()

            messages.success(request, "Product updated successfully.")
            if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                return JsonResponse({'success': True})
        except Exception as e:
            messages.error(request, f"Error: {str(e)}")

    return redirect('producttreatment_db')

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
def product_details(request, product_id):
    from .models import BranchProduct
    product = get_object_or_404(Product, product_id=product_id, is_deleted=False)
    supplier = Supplier.objects.filter(supplier_id=product.supplier_id).first()
    query_string = request.GET.urlencode()

    try:
        employee_branch = get_user_branch(request)
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

@never_cache
@login_required(login_url='login')
@role_required(['Owner'])
def product_delete(request, product_id):
    product = get_object_or_404(Product, product_id=product_id, is_deleted=False)
    if request.method == 'POST':
        product.is_deleted = True
        product.save()
        messages.success(request, f'Product "{product.product_name}" deleted successfully.')
    return redirect('producttreatment_db')
# ─────────────────────────────────────────────
# TREATMENT VIEWS
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner'])
def treatment_add(request):
    if not is_owner(request.user):
        messages.error(request, "You are not authorized to access this page.")
        referer = request.META.get('HTTP_REFERER')
        return redirect(referer if referer else 'producttreatment_db')

    if request.method == 'POST':
        name       = request.POST.get('treatment_name', '').strip()
        ttype      = request.POST.get('treatment_type', '').strip()
        cost       = request.POST.get('treatment_cost', '').strip()
        desc       = request.POST.get('description', '').strip()
        branch_ids = request.POST.getlist('branch')
        status     = True

        if not all([name, ttype, cost, desc, branch_ids]):
            messages.error(request, 'All fields are required.')
            return redirect('producttreatment_db')

        # Duplicate name check
        if Treatment.objects.filter(treatment_name__iexact=name, treatment_type__iexact=ttype, is_deleted=False).exists():
            return JsonResponse({'error': f'A treatment named "{name}" with type "{ttype}" already exists.'}, status=400)

        # Max length check
        if len(name) > MAX_NAME_LENGTH:
            messages.error(request, f'Treatment name must not exceed {MAX_NAME_LENGTH} characters.')
            return redirect('producttreatment_db')

        # Cost validation
        try:
            cost_val = float(cost)
        except ValueError:
            messages.error(request, 'Invalid treatment cost value.')
            return redirect('producttreatment_db')

        if cost_val <= 0:
            messages.error(request, 'Treatment cost cannot be negative.')
            return redirect('producttreatment_db')

        if cost_val > MAX_COST:
            messages.error(request, f'Treatment cost cannot exceed {MAX_COST:,.2f}.')
            return redirect('producttreatment_db')

        try:
            with transaction.atomic():
                treatment = Treatment.objects.create(
                    treatment_name=name,
                    treatment_type=ttype,
                    treatment_cost=cost_val,
                    description=desc,
                )
                for bid in branch_ids:
                    BranchTreatment.objects.create(
                        treatment=treatment,
                        branch_id=bid,
                        availability_status=status,
                    )
            messages.success(request, 'Treatment added successfully.')
            if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                return JsonResponse({'success': True})
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')

    return redirect('producttreatment_db')


@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def treatment_update(request, treatment_id):
    treatment = get_object_or_404(Treatment, treatment_id=treatment_id, is_deleted=False)

    if is_owner(request.user):
        branch = get_user_branch(request)
        if not branch:
            messages.error(request, "Please select a specific branch from the navbar before updating treatments.")
            return redirect('producttreatment_db')
    else:
        try:
            branch = request.user.employeeprofile.branch
        except:
            branch = None

        if not branch:
            messages.error(request, "No branch assigned to your account. Please contact the owner.")
            return redirect('producttreatment_db')

    branch_treatment, created = BranchTreatment.objects.get_or_create(
        treatment=treatment,
        branch=branch,
        defaults={'availability_status': True}
    )

    if request.method == 'POST':
        name   = request.POST.get('treatment_name', '').strip()
        ttype  = request.POST.get('treatment_type', '').strip()
        cost   = request.POST.get('treatment_cost', '').strip()
        desc   = request.POST.get('description', '').strip()
        status = request.POST.get('availability_status') == 'on'

        if not all([name, ttype, cost, desc]):
            messages.error(request, "All fields required.")
        else:
            # Duplicate name check (exclude current treatment)
            if Treatment.objects.filter(treatment_name__iexact=name, treatment_type__iexact=ttype, is_deleted=False).exclude(treatment_id=treatment_id).exists():
                return JsonResponse({'error': f'A treatment named "{name}" with type "{ttype}" already exists.'}, status=400)

            # Max length check
            if len(name) > MAX_NAME_LENGTH:
                messages.error(request, f'Treatment name must not exceed {MAX_NAME_LENGTH} characters.')
                return redirect('producttreatment_db')

            # Cost validation
            try:
                cost_val = float(cost)
            except ValueError:
                messages.error(request, 'Invalid treatment cost value.')
                return redirect('producttreatment_db')

            if cost_val <= 0:
                messages.error(request, 'Treatment cost cannot be negative.')
                return redirect('producttreatment_db')

            if cost_val > MAX_COST:
                messages.error(request, f'Treatment cost cannot exceed {MAX_COST:,.2f}.')
                return redirect('producttreatment_db')

            try:
                treatment.treatment_name = name
                treatment.treatment_type = ttype
                treatment.treatment_cost = cost_val
                treatment.description    = desc
                treatment.save()

                branch_treatment.availability_status = status
                branch_treatment.save()

                messages.success(request, "Treatment updated successfully.")
                if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                    return JsonResponse({'success': True})
            except Exception as e:
                messages.error(request, f"Error: {str(e)}")

    return redirect('producttreatment_db')

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
def treatment_details(request, treatment_id):
    from .models import BranchTreatment
    treatment = get_object_or_404(Treatment, treatment_id=treatment_id, is_deleted=False)
    query_string = request.GET.urlencode()
    branch = get_user_branch(request)

    branch_treatment = BranchTreatment.objects.filter(
        treatment=treatment,
        branch=branch
    ).first() if branch else None

    return render(request, 'clinic/treatment_details.html', {
        'treatment': treatment,
        'branch': branch,
        'branch_treatment': branch_treatment,
        'query_string': query_string
    })

@never_cache
@login_required(login_url='login')
@role_required(['Owner'])
def treatment_delete(request, treatment_id):
    treatment = get_object_or_404(Treatment, treatment_id=treatment_id, is_deleted=False)
    if request.method == 'POST':
        treatment.is_deleted = True
        treatment.save()
        messages.success(request, f'Treatment "{treatment.treatment_name}" deleted successfully.')
    return redirect('producttreatment_db')
# ─────────────────────────────────────────────
# SUPPLIER VIEWS
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
def check_supplier(request):
    name = request.GET.get('name', '').strip()
    exclude_id = request.GET.get('exclude_id')

    qs = Supplier.objects.filter(supplier_name__iexact=name, is_deleted=False)
    if exclude_id:
        qs = qs.exclude(supplier_id=exclude_id)

    return JsonResponse({'taken': qs.exists()})

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def supplier_db(request):
    # ── 1. CATCH THE FORM DATA (POST REQUEST) ──
    if request.method == 'POST':
        if not is_owner(request.user):
            messages.error(request, "You are not authorized to access this page.")
            return redirect('supplier_db')
        name = request.POST.get('supplier_name', '').strip()
        person = request.POST.get('contact_person', '').strip()
        number = request.POST.get('supplier_contact_number', '').strip()
        address = request.POST.get('supplier_address', '').strip()

        # 1. Check if required fields are missing
        if not name or not person:
            messages.error(request, 'Supplier Name and Contact Person are required.')
            return redirect('supplier_db')

        # 2. CHECK FOR CHARACTER LENGTHS (Matched to your models.py)
        if len(name) > 150 or len(person) > 100 or len(number) > 11 or len(address) > 300:
            messages.error(request, 'Some fields exceed maximum character length.')
            return redirect('supplier_db')

        # 3. CHECK FOR DUPLICATES (Case-insensitive)
        if Supplier.objects.filter(supplier_name__iexact=name, is_deleted=False).exists():
            messages.error(request, 'Supplier already exists.')
            return redirect('supplier_db')

        # 4. If all clear, create the supplier
        Supplier.objects.create(
            supplier_name=name,
            contact_person=person,
            supplier_contact_number=number,
            supplier_address=address
        )
        messages.success(request, f'Supplier "{name}" added successfully.')
        return redirect('supplier_db')

    # ── 2. DISPLAY THE PAGE & SEARCH (GET REQUEST) ──
    query = request.GET.get("q", "").strip()
    suppliers = Supplier.objects.filter(is_deleted=False)

    if query:
        suppliers = suppliers.filter(
            Q(supplier_name__icontains=query) |
            Q(contact_person__icontains=query) 
        )
        
    return render(request, 'clinic/supplier_db.html', {
        'suppliers': suppliers.order_by('supplier_name'),
        'query': query,
        'user_is_owner': is_owner(request.user),
    })

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def supplier_details(request, supplier_id):
    supplier = get_object_or_404(Supplier, supplier_id=supplier_id, is_deleted=False)
    # Get products provided by this supplier
    products = Product.objects.filter(supplier=supplier, is_deleted=False)    
    return render(request, 'clinic/supplier_details.html', {
        'supplier': supplier,
        'products': products
    })

@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician'])
def supplier_update(request, supplier_id):
    # Find the specific supplier in the database
    supplier = get_object_or_404(Supplier, supplier_id=supplier_id, is_deleted=False)

    if not is_owner(request.user):
        messages.error(request, "You are not authorized to access this page.")
        return redirect('supplier_db')
    
    if request.method == 'POST':
        # Grab the updated data from the modal
        new_name = request.POST.get('supplier_name', '').strip()
        new_person = request.POST.get('contact_person', '').strip()
        new_number = request.POST.get('supplier_contact_number', '').strip()
        new_address = request.POST.get('supplier_address', '').strip()
        
        # 1. Check for empty required fields
        if not new_name or not new_person:
            messages.error(request, 'Supplier Name and Contact Person cannot be empty.')
            return redirect('supplier_db')
            
        # 2. CHECK SPECIFICALLY FOR INVALID CONTACT NUMBER LENGTH
        # This checks if it's over 11 characters. 
        # (Change "> 11" to "!= 11" if it must be EXACTLY 11 digits)
        if new_number and len(new_number) > 11:
            messages.error(request, 'Invalid Supplier Contact Number Length.')
            return redirect('supplier_db')

        # 3. Check character lengths for the remaining fields to match database limits
        if len(new_name) > 150 or len(new_person) > 100 or len(new_address) > 300:
            messages.error(request, 'Some fields exceed maximum character length.')
            return redirect('supplier_db')
            
        # 4. CHECK FOR DUPLICATES
        # if they only want to update their contact number or address.
        if Supplier.objects.filter(supplier_name__iexact=new_name, is_deleted=False).exclude(supplier_id=supplier_id).exists():
            messages.error(request, 'Supplier already exists.')
            return redirect('supplier_db')
            
        # 5. If validation passes, update and save
        supplier.supplier_name = new_name
        supplier.contact_person = new_person
        supplier.supplier_contact_number = new_number
        supplier.supplier_address = new_address
        supplier.save()
        
        messages.success(request, f'Supplier "{supplier.supplier_name}" updated successfully.')
            
    return redirect('supplier_db')

@never_cache
@login_required(login_url='login')
@role_required(['Owner'])
def supplier_delete(request, supplier_id):
    supplier = get_object_or_404(Supplier, supplier_id=supplier_id, is_deleted=False)

    if request.method == 'POST':
        try:
            supplier.is_deleted = True
            supplier.save()
            messages.success(request, "Supplier deleted successfully.")
        except Exception as e:
            messages.error(request, f"Error deleting supplier: {str(e)}")

    return redirect('supplier_db')

# ─────────────────────────────────────────────
# EMPLOYEE VIEWS (Owner Only)
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def employee_list(request):
    last_user = User.objects.order_by('id').last()
    next_account_id = (last_user.id + 1) if last_user else 1

    # Start with all users
    employees = User.objects.all().order_by('username')
    
    # ─── FIXED: Apply Branch Filter from Session ───
    selected_branch = request.session.get('selected_branch')

    profile = getattr(request.user, 'employeeprofile', None)

    if selected_branch and profile and profile.all_branches == False:
        employees = employees.filter(employeeprofile__branch_id=selected_branch)
    # ───────────────────────────────────────────────
    
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

@never_cache
@login_required(login_url='login')
def check_username(request):
    username = request.GET.get('username', '').strip()
    exclude_id = request.GET.get('exclude_id')
    
    qs = User.objects.filter(username__iexact=username)
    if exclude_id:
        qs = qs.exclude(id=exclude_id)
    
    return JsonResponse({'taken': qs.exists()})

@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def add_employee(request):
    if request.method == 'POST':
        role_name = request.POST.get('role')
        if role_name == 'Owner':
            all_branches = True
        elif role_name == 'Aesthetician':
            all_branches = False
        branch_id = request.POST.get('branch_id')
        all_branches = request.POST.get('all_branches') == 'on'
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

                if all_branches:
                    branch = None
                else:
                    if not branch_id:
                        messages.error(request, "Please select a branch.")
                        return redirect('employee_list')

                    try:
                        branch = ClinicBranch.objects.get(branch_id=branch_id)
                    except ClinicBranch.DoesNotExist:
                        messages.error(request, "Selected branch does not exist.")
                        return redirect('employee_list')

                EmployeeProfile.objects.create(
                    user=user,
                    branch=branch,
                    all_branches=all_branches
                )

            messages.success(request, f'Employee {username} was successfully added!')
        except Exception as e:
            messages.error(request, f'An error occurred: {str(e)}')

    return redirect('employee_list')

@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def update_employee(request, employee_id):
    if request.method == 'POST':
        all_branches = request.POST.get('all_branches') == 'on'
        user = get_object_or_404(User, id=employee_id)
        role_name = request.POST.get('role')
        if role_name == 'Owner':
            all_branches = True
        elif role_name == 'Aesthetician':
            all_branches = False
        branch_id = request.POST.get('branch_id')
        username = request.POST.get('username', '').strip()
        is_active = request.POST.get('is_active') == 'True'
        full_name = request.POST.get('full_name', '').strip()
        new_password = request.POST.get('new_password')
        confirm_password = request.POST.get('confirm_password') 
        
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

                if new_password:
                    if new_password != confirm_password:
                        messages.error(request, "New passwords do not match")
                        return redirect('employee_list')

                    user.set_password(new_password)
                    user.save()
                    update_session_auth_hash(request, user)  # keeps you logged in
                else:
                    user.save()
                
                if role_name:
                    user.groups.clear()
                    user.groups.add(Group.objects.get(name=role_name))
                
                profile, _ = EmployeeProfile.objects.get_or_create(user=user)
                profile.all_branches = all_branches
                if all_branches:
                    profile.branch = None
                else:
                    profile.branch = ClinicBranch.objects.get(branch_id=branch_id)
                profile.save()

            messages.success(request, f'Employee {username} was successfully updated!')
        except Exception as e:
            messages.error(request, f'An error occurred while updating: {str(e)}')

    return redirect('employee_list')

@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def employee_details(request, id):
    return render(request, 'clinic/employee_details.html', {
        'employee': get_object_or_404(User, id=id)
    })

# ─────────────────────────────────────────────
# BRANCH VIEWS (Owner Only)
# ─────────────────────────────────────────────
@never_cache
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

@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def add_branch(request):
    if request.method == 'POST':
        location = request.POST.get('branch_location', '').strip()
        address = request.POST.get('branch_address', '').strip()
        
        if not location or not address:
            messages.error(request, 'All fields required.')
            return redirect('branch_list')
            
        if ClinicBranch.objects.filter(branch_location__iexact=location).exists():
            messages.error(request, 'Branch name already exists.')
            return redirect('branch_list')
        ClinicBranch.objects.create(branch_location=location, branch_address=address)
        
        messages.success(request, 'Branch creation successful')
            
    return redirect('branch_list')

@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def update_branch(request, branch_id):
    if request.method == 'POST':
        branch = get_object_or_404(ClinicBranch, branch_id=branch_id)
        new_location = request.POST.get('branch_location', '').strip()
        new_address = request.POST.get('branch_address', '').strip()
        
        if not new_location or not new_address:
            messages.error(request, 'All fields required.')
            return redirect('branch_list')
            
        if ClinicBranch.objects.filter(branch_location__iexact=new_location).exclude(branch_id=branch_id).exists():
            messages.error(request, 'Branch name already exists.')
            return redirect('branch_list')
            
        branch.branch_location = new_location
        branch.branch_address = new_address
        branch.save()
        
        messages.success(request, 'Update successful')
            
    return redirect('branch_list')

@never_cache
@login_required(login_url='login')
@user_passes_test(is_owner, login_url='login')
def delete_branch(request, branch_id):
    if request.method == 'POST':
        branch = get_object_or_404(ClinicBranch, branch_id=branch_id)
        branch.delete() 

        messages.success(request, 'Branch deleted')
        
    return redirect('branch_list')

# ─────────────────────────────────────────────
# MY PROFILE (For All Authenticated Users)
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
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

# ═══════════════════════════════════════════════════════════════
# EXPORT FUNCTIONS (CORRECTED)
# ═══════════════════════════════════════════════════════════════

@never_cache
@login_required(login_url='login')
def export_inventory_csv(request):
    """Export inventory shipments to CSV."""
    response = HttpResponse(content_type='text/csv')
    response.write('\ufeff')  # BOM for Excel
    response['Content-Disposition'] = f'attachment; filename="inventory_{date.today()}.csv"'
    
    writer = csv.writer(response)
    writer.writerow([
        'Record ID', 'Shipment Date (DD-MM-YYYY)', 'Shipment Name (Product)', 
        'Branch Location', 'Supplier ID', 'Supplier Name'
    ])

    for s in InventoryShipment.objects.select_related('branch', 'supplier'):
        shipment_date = s.date_received.strftime('%d-%m-%Y') if s.date_received else '-'
        writer.writerow([
            s.inventory_record_id,
            shipment_date,
            s.received_product_name,
            s.branch.branch_location if s.branch else "-",
            s.supplier.supplier_id if s.supplier else "-",
            s.supplier.supplier_name if s.supplier else "-"
        ])

    return response


@never_cache
@login_required(login_url='login')
def export_patients_csv(request):
    """Export patients to CSV."""
    response = HttpResponse(content_type='text/csv')
    response.write('\ufeff')  # BOM for Excel
    response['Content-Disposition'] = f'attachment; filename="patient_{date.today()}.csv"'

    writer = csv.writer(response)
    writer.writerow([
        'Patient ID', 'Full Name (Last, First Middle)', 'Contact Number',
        'Address', 'Birthday (MM-DD-YYYY)', 'Sex', 'Notes (consolidated in one cell)'
    ])

    patients = Patient.objects.all()

    for p in patients:
        full_name = " ".join(
            filter(None, [f"{p.last_name},", p.first_name, p.middle_name, p.suffix])
        )
                # Consolidate notes from sales transactions
        notes = SalesTransaction.objects.filter(patient=p).order_by('transaction_date')
        notes_str = " | ".join([
            f"#{n.transaction_id} ({n.transaction_date.strftime('%b %d, %Y')}): {n.notes}"
            for n in notes if n.notes
        ])

        bday_str = p.birthday.strftime('%m-%d-%Y') if p.birthday else '-'

        writer.writerow([
            p.patient_id,
            full_name,
            p.patient_contact_number,
            p.patient_address,
            bday_str,
            p.sex,
            notes_str
        ])
    
    return response


@never_cache
@login_required(login_url='login')
def export_sales_csv(request):
    """Export sales transactions to CSV."""
    response = HttpResponse(content_type='text/csv')
    response.write('\ufeff')  # BOM for Excel
    response['Content-Disposition'] = f'attachment; filename="sales_{date.today()}.csv"'

    writer = csv.writer(response)
    writer.writerow([
        'Transaction ID', 'Transaction Date (DD-MM-YYYY)', 'Branch Name',
        'Patient ID', 'Full Name (Last, First Middle)',
        'Treatments (Qty: x - Price)', 'Products (Qty: x - Price)',
        'Mode of Payment', 'Total Amount'
    ])

    transactions = SalesTransaction.objects.select_related('patient', 'branch').prefetch_related('transactionitem_set')

    for t in transactions:
        p = t.patient

        full_name = " ".join(
            filter(None, [f"{p.last_name},", p.first_name, p.middle_name, p.suffix])
        )

        treatments = [i for i in t.transactionitem_set.all() if i.treatment is not None]
        treatments_str = " | ".join([
            f"{i.treatment.treatment_name} (Qty: {i.quantity_purchased} - {i.subtotal})"
            for i in treatments
        ])

        products = [i for i in t.transactionitem_set.all() if i.product is not None]
        products_str = " | ".join([
            f"{i.product.product_name} (Qty: {i.quantity_purchased} - {i.subtotal})"
            for i in products
        ])

        writer.writerow([
            t.transaction_id,
            t.transaction_date.strftime('%d-%m-%Y'),
            t.branch.branch_location if t.branch else "-",
            p.patient_id,
            full_name,
            treatments_str,
            products_str,
            t.mode_of_payment,
            f"{t.total_amount:.2f}"
        ])
    
    return response


# ═══════════════════════════════════════════════════════════════
# HELPER FUNCTIONS FOR IMPORTS
# ═══════════════════════════════════════════════════════════════

def parse_csv_file(csv_file):
    """Safely parse CSV file with UTF-8-sig encoding."""
    try:
        data_set = csv_file.read().decode('utf-8-sig')
        io_string = io.StringIO(data_set)
        reader = csv.reader(io_string)
        next(reader)  # Skip header row
        return reader
    except Exception as e:
        return None


def parse_date(date_str, date_format, field_name="Date"):
    """Parse date string with validation."""
    if not date_str or date_str.strip() in ['-', '', 'N/A']:
        return None, f"{field_name} is missing"
    
    try:
        parsed_date = datetime.strptime(date_str.strip(), date_format).date()
        
        # Validate date range
        if parsed_date.year < 1900:
            return None, f"{field_name} must be 01/01/1900 or later"
        if parsed_date.year > 2030:
            return None, f"{field_name} must be 12/31/2030 or earlier"
            
        return parsed_date, None
    except ValueError:
        return None, f"Invalid {field_name} format (expected {date_format})"


def validate_row_length(row, expected_length, row_num):
    """Check if row has expected number of columns."""
    if len(row) < expected_length:
        return False, f"Row {row_num}: Expected {expected_length} columns, got {len(row)}"
    return True, None


def parse_item_string(item_str):
    """Parse item string in format: 'Name (Qty: X - Price)'."""
    if not item_str or item_str.strip() in ['-', '']:
        return []
    
    items = []
    pattern = re.compile(r'^(.*?)\s*\(Qty:\s*(\d+)\s*-\s*([\d.]+)\)$')
    
    for item_text in item_str.split(' | '):
        item_text = item_text.strip()
        if not item_text:
            continue
            
        match = pattern.match(item_text)
        if match:
            name = match.group(1).strip()
            qty = int(match.group(2))
            subtotal = float(match.group(3))
            items.append((name, qty, subtotal))
    
    return items


# ═══════════════════════════════════════════════════════════════
# IMPORT FUNCTIONS (IMPROVED)
# ═══════════════════════════════════════════════════════════════

@never_cache
@login_required(login_url='login')
def import_inventory_csv(request):
    """Import inventory shipments from CSV."""
    if request.method != 'POST':
        return redirect('inventory_db')
    
    csv_file = request.FILES.get('csv_file')
    if not csv_file:
        messages.error(request, "No file uploaded.")
        return redirect('inventory_db')
    
    reader = parse_csv_file(csv_file)
    if reader is None:
        messages.error(request, "Failed to read CSV file. Ensure it's UTF-8 encoded.")
        return redirect('inventory_db')
    
    imported_count = 0
    skipped_count = 0
    errors = []
    
    try:
        with transaction.atomic():
            for row_num, row in enumerate(reader, start=2):
                if not row or all(cell.strip() == '' for cell in row):
                    continue
                
                valid, error = validate_row_length(row, 6, row_num)
                if not valid:
                    errors.append(error)
                    skipped_count += 1
                    continue
                
                record_id = row[0].strip()
                date_str = row[1].strip()
                product_name = row[2].strip()
                branch_location = row[3].strip()
                supplier_id = row[4].strip()
                supplier_name = row[5].strip()
                
                if not all([record_id, product_name, branch_location, supplier_id, supplier_name]):
                    errors.append(f"Row {row_num}: Missing required fields")
                    skipped_count += 1
                    continue
                
                date_received, date_error = parse_date(date_str, '%d-%m-%Y', 'Shipment Date')
                if date_error:
                    date_received = datetime.now().date()
                    errors.append(f"Row {row_num}: {date_error} - using current date")
                
                branch, created = ClinicBranch.objects.get_or_create(
                    branch_location=branch_location
                )
                
                supplier, created = Supplier.objects.get_or_create(
                    supplier_id=supplier_id,
                    defaults={
                        'supplier_name': supplier_name,
                        'contact_person': 'N/A',
                        'supplier_contact_number': '00000000000'
                    }
                )
                
                InventoryShipment.objects.update_or_create(
                    inventory_record_id=record_id,
                    defaults={
                        'received_product_name': product_name,
                        'date_received': date_received,
                        'branch': branch,
                        'supplier': supplier
                    }
                )
                
                imported_count += 1
            
            if errors:
                messages.warning(
                    request,
                    f"Inventory import completed with warnings. "
                    f"Imported: {imported_count}, Skipped: {skipped_count}. "
                    f"First error: {errors[0]}"
                )
            else:
                messages.success(
                    request,
                    f"Inventory imported successfully. {imported_count} records imported."
                )
    
    except Exception as e:
        messages.error(request, f"Import failed: {str(e)}")
    
    return redirect('inventory_db')


@never_cache
@login_required(login_url='login')
def import_patients_csv(request):
    """Import patients from CSV."""
    if request.method != 'POST':
        return redirect('patient_db')
    
    csv_file = request.FILES.get('csv_file')
    if not csv_file:
        messages.error(request, "No file uploaded.")
        return redirect('patient_db')
    
    reader = parse_csv_file(csv_file)
    if reader is None:
        messages.error(request, "Failed to read CSV file. Ensure it's UTF-8 encoded.")
        return redirect('patient_db')
    
    imported_count = 0
    skipped_count = 0
    errors = []
    
    try:
        with transaction.atomic():
            for row_num, row in enumerate(reader, start=2):
                if not row or all(cell.strip() == '' for cell in row):
                    continue
                
                valid, error = validate_row_length(row, 7, row_num)
                if not valid:
                    errors.append(error)
                    skipped_count += 1
                    continue
                
                patient_id = row[0].strip()
                full_name = row[1].strip()
                contact = row[2].strip()
                address = row[3].strip()
                birthday_str = row[4].strip()
                sex = row[5].strip()
                notes = row[6].strip()
                
                if not all([patient_id, full_name, contact, address, birthday_str, sex]):
                    errors.append(f"Row {row_num}: Missing required fields")
                    skipped_count += 1
                    continue
                
                # Parse name
                last_name = ''
                first_name = ''
                middle_name = ''
                suffix = ''
                
                if ',' in full_name:
                    parts = full_name.split(',', 1)
                    last_name = parts[0].strip()
                    
                    if len(parts) > 1:
                        other_parts = parts[1].strip().split()
                        if len(other_parts) >= 1:
                            first_name = other_parts[0]
                        if len(other_parts) >= 2:
                            middle_name = other_parts[1]
                        if len(other_parts) >= 3:
                            suffix = ' '.join(other_parts[2:])
                else:
                    last_name = full_name
                
                # Validate contact (11 digits)
                if len(contact) != 11 or not contact.isdigit():
                    errors.append(f"Row {row_num}: Invalid contact number (must be 11 digits)")
                    skipped_count += 1
                    continue
                
                # Validate birthday
                birthday, date_error = parse_date(birthday_str, '%m-%d-%Y', 'Birthday')
                if date_error:
                    errors.append(f"Row {row_num}: {date_error}")
                    skipped_count += 1
                    continue
                
                # Validate sex
                if sex not in ['M', 'F', 'O']:
                    errors.append(f"Row {row_num}: Invalid sex (must be M, F, or O)")
                    skipped_count += 1
                    continue
                
                # Save/update patient
                Patient.objects.update_or_create(
                    patient_id=patient_id,
                    defaults={
                        'last_name': last_name,
                        'first_name': first_name,
                        'middle_name': middle_name,
                        'suffix': suffix,
                        'patient_contact_number': contact,
                        'patient_address': address,
                        'birthday': birthday,
                        'sex': sex,
                        'notes': notes,
                        'is_deleted': False
                    }
                )
                
                imported_count += 1
            
            # ✅ SIMPLE SUCCESS/FAIL MESSAGE (as requested)
            if imported_count > 0:
                messages.success(
                    request,
                    f"Patients imported successfully. {imported_count} records imported."
                )
            else:
                messages.error(request, "Failed to import patients.")
    
    except Exception as e:
        messages.error(request, f"Import failed: {str(e)}")
    
    return redirect('patient_db')

@never_cache
@login_required(login_url='login')
def import_sales_csv(request):
    """Import sales transactions from CSV."""
    if request.method != 'POST':
        return redirect('sales_db')
    
    csv_file = request.FILES.get('csv_file')
    if not csv_file:
        messages.error(request, "No file uploaded.")
        return redirect('sales_db')
    
    reader = parse_csv_file(csv_file)
    if reader is None:
        messages.error(request, "Failed to read CSV file. Ensure it's UTF-8 encoded.")
        return redirect('sales_db')
    
    imported_count = 0
    skipped_count = 0
    errors = []
    
    try:
        with transaction.atomic():
            for row_num, row in enumerate(reader, start=2):
                if not row or all(cell.strip() == '' for cell in row):
                    continue
                
                valid, error = validate_row_length(row, 9, row_num)
                if not valid:
                    errors.append(error)
                    skipped_count += 1
                    continue
                
                transaction_id = row[0].strip()
                date_str = row[1].strip()
                branch_name = row[2].strip()
                patient_id = row[3].strip()
                full_name = row[4].strip()
                treatments_str = row[5].strip()
                products_str = row[6].strip()
                payment_mode = row[7].strip()
                total_amount_str = row[8].strip()
                
                if not all([transaction_id, date_str, patient_id, payment_mode, total_amount_str]):
                    errors.append(f"Row {row_num}: Missing required fields")
                    skipped_count += 1
                    continue
                
                transaction_date, date_error = parse_date(date_str, '%d-%m-%Y', 'Transaction Date')
                if date_error:
                    errors.append(f"Row {row_num}: {date_error}")
                    skipped_count += 1
                    continue
                
                branch = None
                if branch_name:
                    branch = ClinicBranch.objects.filter(branch_location=branch_name).first()
                
                patient = Patient.objects.filter(patient_id=patient_id).first()
                if not patient:
                    errors.append(f"Row {row_num}: Patient ID {patient_id} not found")
                    skipped_count += 1
                    continue
                
                try:
                    total_amount = float(total_amount_str)
                except ValueError:
                    errors.append(f"Row {row_num}: Invalid total amount")
                    skipped_count += 1
                    continue
                
                valid_payment_modes = ['Cash', 'Card', 'GCash', 'Bank Transfer']
                if payment_mode not in valid_payment_modes:
                    errors.append(f"Row {row_num}: Invalid payment mode '{payment_mode}'")
                    skipped_count += 1
                    continue
                
                transaction_obj, created = SalesTransaction.objects.update_or_create(
                    transaction_id=transaction_id,
                    defaults={
                        'transaction_date': transaction_date,
                        'branch': branch,
                        'patient': patient,
                        'mode_of_payment': payment_mode,
                        'total_amount': total_amount
                    }
                )
                
                if not created:
                    transaction_obj.transactionitem_set.all().delete()
                
                # Create treatment items
                treatment_items = parse_item_string(treatments_str)
                for name, qty, subtotal in treatment_items:
                    treatment = Treatment.objects.filter(treatment_name__iexact=name).first()
                    if treatment:
                        TransactionItem.objects.create(
                            transaction=transaction_obj,
                            treatment=treatment,
                            quantity_purchased=qty,
                            subtotal=subtotal
                        )
                    else:
                        errors.append(f"Row {row_num}: Treatment '{name}' not found")
                
                # Create product items
                product_items = parse_item_string(products_str)
                for name, qty, subtotal in product_items:
                    product = Product.objects.filter(product_name__iexact=name).first()
                    if product:
                        TransactionItem.objects.create(
                            transaction=transaction_obj,
                            product=product,
                            quantity_purchased=qty,
                            subtotal=subtotal
                        )
                    else:
                        errors.append(f"Row {row_num}: Product '{name}' not found")
                
                imported_count += 1
            
            if errors:
                error_summary = '; '.join(errors[:5])
                if len(errors) > 5:
                    error_summary += f" ... and {len(errors) - 5} more"
                
                messages.warning(
                    request,
                    f"Sales import completed with warnings. "
                    f"Imported: {imported_count}, Skipped: {skipped_count}. "
                    f"Errors: {error_summary}"
                )
            else:
                messages.success(
                    request,
                    f"Sales imported successfully. {imported_count} transactions imported."
                )
    
    except Exception as e:
        messages.error(request, f"Import failed: {str(e)}")
    
    return redirect('sales_db')
# ─────────────────────────────────────────────
# LOW STOCK ALERTS
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Aesthetician', 'Sales'])
def low_stock_alerts(request):
    branch = get_user_branch(request)

    if branch:
        low_stock_items = BranchProduct.objects.filter(
            branch=branch,
            stock_quantity__lte=models.F('quantity_minimum'),
            quantity_minimum__gt=0
        ).select_related('product__supplier', 'branch')
    else:
        low_stock_items = BranchProduct.objects.filter(
            stock_quantity__lte=models.F('quantity_minimum'),
            quantity_minimum__gt=0
        ).select_related('product__supplier', 'branch')

    return JsonResponse({
        'count': low_stock_items.count(),
        'items': [
            {
                'product_name':  item.product.product_name,
                'branch':        item.branch.branch_location,
                'stock':         item.stock_quantity,
                'minimum':       item.quantity_minimum,
                'unit_cost':     str(item.product.unit_cost),
                'supplier_name': item.product.supplier.supplier_name,
            }
            for item in low_stock_items
        ]
    })    

# ─────────────────────────────────────────────
# DASHBOARD
# ─────────────────────────────────────────────
@never_cache
@login_required(login_url='login')
@role_required(['Owner', 'Sales']) 
def dashboard_view(request):
    try:
        branch = get_user_branch(request)
    except:
        branch = None
    
    sales_qs = SalesTransaction.objects.all()
    items_qs = TransactionItem.objects.select_related('product')

    received_qs = ReceivedProduct.objects.select_related('product', 'inventory_record')

    if branch:
        sales_qs = sales_qs.filter(branch=branch)
        items_qs = items_qs.filter(transaction__branch=branch)
        received_qs = received_qs.filter(branch=branch)

    # --- FLATPICKR DATE FILTER LOGIC ---
    date_filter = request.GET.get('date', '').strip()

    if date_filter:
        try:
            if " to " in date_filter:
                start_str, end_str = date_filter.split(" to ")
                start_date = datetime.strptime(start_str.strip(), "%Y-%m-%d").date()
                end_date = datetime.strptime(end_str.strip(), "%Y-%m-%d").date()
                
                sales_qs = sales_qs.filter(transaction_date__range=[start_date, end_date])
                items_qs = items_qs.filter(transaction__transaction_date__range=[start_date, end_date])
                received_qs = received_qs.filter(inventory_record__date_received__range=[start_date, end_date])
            else:
                single_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
                
                sales_qs = sales_qs.filter(transaction_date=single_date)
                items_qs = items_qs.filter(transaction__transaction_date=single_date)
                received_qs = received_qs.filter(inventory_record__date_received=single_date)
        except ValueError:
            pass 
    # --- END FLATPICKR DATE FILTER LOGIC ---

    # Top Cards 
    total_transactions = sales_qs.count()
    products_sold = items_qs.filter(product__isnull=False).aggregate(Sum('quantity_purchased'))['quantity_purchased__sum'] or 0

    #Treatments Administered 
    treatments_administered = items_qs.filter(treatment__isnull=False).aggregate(Sum('quantity_purchased'))['quantity_purchased__sum'] or 0

    # Products Restocked Metric
    products_restocked = received_qs.aggregate(Sum('quantity_received'))['quantity_received__sum'] or 0

    
    # Total Sales (Moved to Revenue Breakdown)
    total_sales = sales_qs.aggregate(Sum('total_amount'))['total_amount__sum'] or 0

    # CHART DATA CALCULATIONS 
    
    # Revenue Breakdown
    revenue_products = sales_qs.aggregate(Sum('total_price_of_products'))['total_price_of_products__sum'] or 0
    revenue_treatments = sales_qs.aggregate(Sum('total_price_of_treatments'))['total_price_of_treatments__sum'] or 0

    # Top Moving Inventory
    top_products = items_qs.filter(product__isnull=False) \
        .values('product__product_name') \
        .annotate(total_sold=Sum('quantity_purchased')) \
        .order_by('-total_sold')[:5]
        
    top_product_names = [p['product__product_name'] for p in top_products]
    top_product_sales = [p['total_sold'] for p in top_products]

    # NEW Most Restocked Products (Replaces Low Stock Table)
    most_restocked = received_qs.values('product__product_name') \
        .annotate(total_restocked=Sum('quantity_received')) \
        .order_by('-total_restocked')[:5]
        
    restocked_names = [p['product__product_name'] for p in most_restocked]
    restocked_counts = [p['total_restocked'] for p in most_restocked]

    # Sales Trend
    thirty_days_ago = timezone.now().date() - timedelta(days=30)
    trend_data = sales_qs.filter(transaction_date__gte=thirty_days_ago) \
        .values('transaction_date') \
        .annotate(daily_sales=Sum('total_amount')) \
        .order_by('transaction_date')

    trend_dates = [t['transaction_date'].strftime('%d %b %y') for t in trend_data]
    trend_sales = [float(t['daily_sales']) for t in trend_data]

    context = {
        'total_sales': total_sales, 
        'total_transactions': total_transactions,
        'products_sold': products_sold,
        'products_restocked': products_restocked,
        'treatments_administered': treatments_administered,
        'revenue_products': float(revenue_products),
        'revenue_treatments': float(revenue_treatments),
        'top_product_names': json.dumps(top_product_names),
        'top_product_sales': json.dumps(top_product_sales),
        'trend_dates': json.dumps(trend_dates),
        'trend_sales': json.dumps(trend_sales),
        'restocked_names': json.dumps(restocked_names),
        'restocked_counts': json.dumps(restocked_counts),
    }

    return render(request, 'clinic/dashboard.html', context)