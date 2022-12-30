from django.urls import path
from lstmApp import views

urlpatterns = [
    path("" , views.base , name="base"),
    path("predict" , views.predict , name="predict"),
]
