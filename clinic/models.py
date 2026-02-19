from django.db import models

# 1. PATIENT 
class Patient(models.Model):
    patient_id = models.AutoField(primary_key=True) # INT(4) 
    last_name = models.CharField(max_length=50)
    first_name = models.CharField(max_length=50)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    suffix = models.CharField(max_length=10, blank=True, null=True)
    patient_address = models.CharField(max_length=300)
    patient_contact_number = models.CharField(max_length=11) # INT(11) in dictionary
    birthday = models.DateField()
    sex = models.CharField(max_length=1) # "M", "F", "O"

    def __str__(self):
        return f"{self.last_name}, {self.first_name}"

# 3. SUPPLIER 
class Supplier(models.Model):
    supplier_id = models.AutoField(primary_key=True) # INT(3) 
    supplier_name = models.CharField(max_length=150)
    contact_person = models.CharField(max_length=100)
    supplier_contact_number = models.CharField(max_length=11) # INT(11) in dictionary
    supplier_address = models.CharField(max_length=300, blank=True, null=True)

    def __str__(self):
        return self.supplier_name

# 4. PRODUCT 
class Product(models.Model):
    product_id = models.AutoField(primary_key=True) # INT(5) 
    product_name = models.CharField(max_length=100)
    product_type = models.CharField(max_length=30) # Cream, Toner, etc.
    description = models.CharField(max_length=500, blank=True, null=True)
    unit_cost = models.DecimalField(max_digits=8, decimal_places=2)
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE)

    def __str__(self):
        return self.product_name

# 5. CLINIC_BRANCH 
class ClinicBranch(models.Model):
    branch_id = models.AutoField(primary_key=True) # INT(1) 
    branch_location = models.CharField(max_length=100)
    branch_address = models.CharField(max_length=300)

    def __str__(self):
        return self.branch_location

# 2. SALES_TRANSACTION 
class SalesTransaction(models.Model):
    transaction_id = models.AutoField(primary_key=True) # INT(7) 
    transaction_date = models.DateField(auto_now_add=True)
    mode_of_payment = models.CharField(max_length=20) # Cash, Card, etc.
    total_price_of_products = models.DecimalField(max_digits=8, decimal_places=2, default=0.00, blank=True, null=True)
    total_price_of_treatments = models.DecimalField(max_digits=8, decimal_places=2, default=0.00, blank=True, null=True)
    total_amount = models.DecimalField(max_digits=8, decimal_places=2)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)

    def __str__(self):
        return f"TXN-{self.transaction_id}"

# 6. ACCOUNT 
class Account(models.Model):
    account_id = models.AutoField(primary_key=True) # INT(1) 
    username = models.CharField(max_length=20, unique=True)
    password = models.CharField(max_length=100)
    account_name = models.CharField(max_length=150)
    account_type = models.CharField(max_length=25) # Aesthetician, Owner, etc.
    date_created = models.DateField(auto_now_add=True)
    status = models.BooleanField(default=True) # TRUE = Active
    all_branches = models.BooleanField(default=False)
    branch = models.ForeignKey(ClinicBranch, on_delete=models.CASCADE, blank=True, null=True)

# 7. INVENTORY_SHIPMENT 
class InventoryShipment(models.Model):
    inventory_record_id = models.AutoField(primary_key=True) # INT(6) 
    received_product_name = models.CharField(max_length=100)
    date_received = models.DateField(auto_now_add=True)
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE)
    branch = models.ForeignKey(ClinicBranch, on_delete=models.CASCADE)

# 8. RECEIVED_PRODUCT (Associative) 
class ReceivedProduct(models.Model):
    inventory_record = models.ForeignKey(InventoryShipment, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity_received = models.IntegerField() # Range 1-10,000
    expiration_date = models.DateField()
    branch = models.ForeignKey(ClinicBranch, on_delete=models.CASCADE)

    class Meta:
        unique_together = (('inventory_record', 'product'),)

# 9. BRANCH_PRODUCT (Associative) 
class BranchProduct(models.Model):
    branch = models.ForeignKey(ClinicBranch, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity_minimum = models.IntegerField(default=0) # Range 0-50
    stock_quantity = models.IntegerField(default=0) # Range 0-10,000

    class Meta:
        unique_together = (('branch', 'product'),)

# 10. TREATMENT 
class Treatment(models.Model):
    treatment_id = models.AutoField(primary_key=True) # INT(2) 
    treatment_name = models.CharField(max_length=100)
    treatment_type = models.CharField(max_length=30)
    treatment_cost = models.DecimalField(max_digits=8, decimal_places=2)
    description = models.CharField(max_length=500, blank=True, null=True)

    def __str__(self):
        return self.treatment_name

# 11. BRANCH_TREATMENT (Associative) 
class BranchTreatment(models.Model):
    branch = models.ForeignKey(ClinicBranch, on_delete=models.CASCADE)
    treatment = models.ForeignKey(Treatment, on_delete=models.CASCADE)
    availability_status = models.BooleanField(default=True)

    class Meta:
        unique_together = (('branch', 'treatment'),)

# 12. TREATMENT_PRODUCT (Associative) 
class TreatmentProduct(models.Model):
    branch = models.ForeignKey(ClinicBranch, on_delete=models.CASCADE)
    treatment = models.ForeignKey(Treatment, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity_used = models.IntegerField() # INT(2), Range 1-20

    class Meta:
        unique_together = (('branch', 'treatment', 'product'),)

# 13. TRANSACTION_ITEM 
class TransactionItem(models.Model):
    item_id = models.AutoField(primary_key=True) # INT(7) 
    quantity_purchased = models.IntegerField() # Range 1-20
    subtotal = models.DecimalField(max_digits=8, decimal_places=2)
    product = models.ForeignKey(Product, on_delete=models.SET_NULL, null=True, blank=True)
    treatment = models.ForeignKey(Treatment, on_delete=models.SET_NULL, null=True, blank=True)
    transaction = models.ForeignKey(SalesTransaction, on_delete=models.CASCADE)

# 14. PATIENT_VISIT (Associative) 
class PatientVisit(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    branch = models.ForeignKey(ClinicBranch, on_delete=models.CASCADE)
    patient_notes = models.TextField(blank=True, null=True)
    
    class Meta:
        unique_together = (('patient', 'branch'),)

    