from django import template

register = template.Library()

@register.simple_tag
def url_replace_param(request, key, value):
    """Return the current querystring with one param replaced/added."""
    params = request.GET.copy()
    params[key] = value
    return params.urlencode()