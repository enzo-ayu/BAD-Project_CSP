# clinic/forms.py
from django import forms
from django.contrib.auth.models import User, Group
from django.contrib.auth.forms import UserCreationForm

class RoleBasedRegistrationForm(UserCreationForm):
    # We create a dropdown for the roles based on Django Groups
    ROLE_CHOICES = (
        ('Owner', 'Owner'),
        ('Aesthetician', 'Aesthetician'),
        ('Sales', 'Sales'),
    )
    role = forms.ChoiceField(choices=ROLE_CHOICES, required=True)

    class Meta(UserCreationForm.Meta):
        model = User
        fields = UserCreationForm.Meta.fields + ('email', 'first_name', 'last_name')

    def save(self, commit=True):
        user = super().save(commit=False)
        if commit:
            user.save()
            # Assign the user to the selected group
            role = self.cleaned_data.get('role')
            group, created = Group.objects.get_or_create(name=role)
            user.groups.add(group)
        return user