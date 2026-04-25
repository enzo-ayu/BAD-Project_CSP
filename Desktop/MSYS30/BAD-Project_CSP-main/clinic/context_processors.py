from .models import ClinicBranch

def branches(request):
    if request.user.is_authenticated:
        return {'all_branches': ClinicBranch.objects.all().order_by('branch_location')}
    return {}