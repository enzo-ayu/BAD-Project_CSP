from django.contrib import admin
from django.urls import path
from django.views.generic import RedirectView
from clinic import views

urlpatterns = [
    path('', RedirectView.as_view(url='/chargeslip/')),
    path('admin/', admin.site.urls),
    path('chargeslip/', views.chargeslip, name='chargeslip'),
    path('chargeslip/view/<int:transaction_id>/', views.view_chargeslip_patient, name='view_chargeslip'),
    path('sales/chargeslip/<int:transaction_id>/', views.view_chargeslip_sales, name='view_chargeslip_sales'),
    path('patients/', views.patient_db, name='patient_db'),


    #path('patients/add/', views.patient_add, name='patient_add'),


    path('patients/<int:patient_id>/', views.patient_details, name='patient_details'),
    path('patients/<int:patient_id>/update/', views.patient_update, name='patient_update'),
    path('patients/<int:patient_id>/delete/', views.patient_delete, name='patient_delete'),
    path('sales/', views.sales_db, name='sales_db'),
    path('sales/<int:transaction_id>/update/', views.sales_update, name='sales_update'),
    path('sales/<int:transaction_id>/delete/', views.sales_delete, name='sales_delete'),
    path('products/add/', views.product_add, name='product_add'),
    #suppliers and inventory
    path('suppliers/', views.supplier_db, name='supplier_db'),
    path('suppliers/add/', views.supplier_add, name='supplier_add'),
    path('suppliers/<int:supplier_id>/', views.supplier_details, name='supplier_details'),
    path('suppliers/<int:supplier_id>/update/', views.supplier_update, name='supplier_update'),
    path('inventory/', views.inventory_db, name='inventory_db'),
    path('inventory/add/', views.inventory_add, name='inventory_add'),
    path('inventory/<int:inventory_record_id>/', views.inventory_details, name='inventory_details'),
    path('inventory/<int:inventory_record_id>/update/', views.inventory_update, name='inventory_update')
]
