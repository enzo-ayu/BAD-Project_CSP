from .models import ClinicBranch

def branches(request):
    if request.user.is_authenticated:
        return {'all_branches': ClinicBranch.objects.filter(is_deleted=False).order_by('branch_location')}
    return {}