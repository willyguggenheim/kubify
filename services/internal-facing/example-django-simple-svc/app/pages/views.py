from django.shortcuts import render  # noqa

# Create your views here.
# pages/views.py
from django.http import HttpResponse


def home_page_view(request):
    return HttpResponse("Hello, Kubify!")
