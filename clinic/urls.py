from django.contrib import admin
from django.urls import path
from django.views.generic import RedirectView
from django.contrib.auth import views as auth_views
from clinic import views

urlpatterns = [
    # Root Redirect
    path('', RedirectView.as_view(url='/login/')),
    path('admin/', admin.site.urls),
    
    # ── Authentication ──
    path('login/', auth_views.LoginView.as_view(template_name='clinic/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(next_page='login'), name='logout'),

    # ── Chargeslip ──
    path('chargeslip/', views.chargeslip, name='chargeslip'),
    path('chargeslip/view/<int:transaction_id>/', views.view_chargeslip_patient, name='view_chargeslip'),
    path('sales/chargeslip/<int:transaction_id>/', views.view_chargeslip_sales, name='view_chargeslip_sales'),
    
    # ── Patients ──
    path('patients/', views.patient_db, name='patient_db'),
    path('patients/add/', views.patient_add, name='patient_add'), # Added missing path here!
    path('patients/<int:patient_id>/', views.patient_details, name='patient_details'),
    path('patients/<int:patient_id>/update/', views.patient_update, name='patient_update'),
    path('patients/<int:patient_id>/delete/', views.patient_delete, name='patient_delete'),
    
    # ── Sales ──
    path('sales/', views.sales_db, name='sales_db'),
    path('sales/<int:transaction_id>/update/', views.sales_update, name='sales_update'),
    path('sales/<int:transaction_id>/delete/', views.sales_delete, name='sales_delete'),
    
    # ── Products ──
    path('products/add/', views.product_add, name='product_add'),

    # ── Employees (Owner Only) ──
    path('employees/', views.employee_list, name='employee_list'),
    path('employees/add/', views.add_employee, name='add_employee'),
    path('employees/update/<int:employee_id>/', views.update_employee, name='update_employee'),
    path('employees/details/<int:id>/', views.employee_details, name='employee_details'),
    
    # ── Branches (Owner Only) ──
    path('branches/', views.branch_list, name='branch_list'),
    path('branches/add/', views.add_branch, name='add_branch'),
    path('branches/update/<str:branch_id>/', views.update_branch, name='update_branch'),
    path('branches/delete/<str:branch_id>/', views.delete_branch, name='delete_branch'),
    path('branches/details/<str:branch_id>/', views.branch_details, name='branch_details'),
]