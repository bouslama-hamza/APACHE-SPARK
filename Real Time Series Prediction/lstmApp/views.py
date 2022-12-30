from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from .lstm import make_whole_prediction

# Create your views here.
def base(request):
    return render(request, 'client_dashboard.html')

@csrf_exempt
def predict(request):
    make_whole_prediction()
    return JsonResponse({'success': True})