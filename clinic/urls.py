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
    
    # ── Employees ──
    path('employees/', views.employee_list, name='employee_list'),
    path('employees/add/', views.add_employee, name='add_employee'),
    path('employees/<int:employee_id>/update/', views.update_employee, name='update_employee'),
    path('employees/<int:id>/', views.employee_details, name='employee_details'),
    path('my-profile/', views.my_profile, name='my_profile'),
    
    # ── Chargeslip ──
    path('chargeslip/', views.chargeslip, name='chargeslip'),
    path('chargeslip/view/<int:transaction_id>/', views.view_chargeslip_patient, name='view_chargeslip'),
    path('sales/chargeslip/<int:transaction_id>/', views.view_chargeslip_sales, name='view_chargeslip_sales'),
    
    # ── Patients ──
    path('patients/', views.patient_db, name='patient_db'), # Fixed the "p  ath" typo here!
    path('patients/add/', views.patient_add, name='patient_add'),
    path('patients/<int:patient_id>/', views.patient_details, name='patient_details'),
    path('patients/<int:patient_id>/update/', views.patient_update, name='patient_update'),
    path('patients/<int:patient_id>/delete/', views.patient_delete, name='patient_delete'),
    
    # ── Sales ──
    path('sales/', views.sales_db, name='sales_db'),
    path('sales/<int:transaction_id>/update/', views.sales_update, name='sales_update'),
    path('sales/<int:transaction_id>/delete/', views.sales_delete, name='sales_delete'),
    
# ── Products & Inventory ──
    path('products/add/', views.product_add, name='product_add'),
    # ── Inventory ──
    path('inventory/', views.inventory_db, name='inventory_db'),
    path('inventory/add/', views.inventory_add, name='inventory_add'),
    path('inventory/<int:record_id>/update/', views.inventory_update, name='inventory_update'),
    path('inventory/<int:record_id>/delete/', views.inventory_delete, name='inventory_delete'),
    path('inventory/<int:record_id>/', views.inventory_details, name='inventory_details'),
    
    # ── Products & Treatments ──    
    path('products-treatments/', views.producttreatment_db, name='producttreatment_db'),
    path('products/add/', views.product_add, name='product_add'),
    path('treatment/add/', views.treatment_add, name='treatment_add'),
    path('product/<int:product_id>/', views.product_details, name='product_details'),
    path('treatment/<int:treatment_id>/', views.treatment_details, name='treatment_details'),
    path('products/<int:product_id>/update/', views.product_update, name='product_update'),
    path('treatments/<int:treatment_id>/update/', views.treatment_update, name='treatment_update'),
    path('product/delete/<int:product_id>/', views.product_delete, name='product_delete'),
    path('treatment/delete/<int:treatment_id>/', views.treatment_delete, name='treatment_delete'),

    # ── Suppliers ──
    path('suppliers/', views.supplier_db, name='supplier_db'),
    path('suppliers/<int:supplier_id>/', views.supplier_details, name='supplier_details'),
    path('suppliers/<int:supplier_id>/update/', views.supplier_update, name='supplier_update'), 
    # ── Branches ──
    path('branches/', views.branch_list, name='branch_list'),
    path('branches/add/', views.add_branch, name='add_branch'),
    path('branches/<int:branch_id>/', views.branch_details, name='branch_details'),
    path('branches/<int:branch_id>/update/', views.update_branch, name='update_branch'),
    path('branches/<int:branch_id>/delete/', views.delete_branch, name='delete_branch'),
]