from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import (
    Patient, Supplier, Product, ClinicBranch, SalesTransaction,
    Account, InventoryShipment, ReceivedProduct, BranchProduct,
    Treatment, BranchTreatment, TreatmentProduct, TransactionItem, PatientVisit
)

# This makes all your tables appear in the Admin Dashboard
admin.site.register(Patient)
admin.site.register(Supplier)
admin.site.register(Product)
admin.site.register(ClinicBranch)
admin.site.register(SalesTransaction)
admin.site.register(Account)
admin.site.register(InventoryShipment)
admin.site.register(ReceivedProduct)
admin.site.register(BranchProduct)
admin.site.register(Treatment)
admin.site.register(BranchTreatment)
admin.site.register(TreatmentProduct)
admin.site.register(TransactionItem)
admin.site.register(PatientVisit)