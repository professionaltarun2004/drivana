import functions_framework
from pricing import calculate_surge
from bookings import create_booking, update_booking_status
from payments import process_payment
from storage import upload_car_image
from gemini import recommend_cars

# Test endpoint to verify Cloud Functions deployment
@functions_framework.http
def hello_world(request):
    return "Hello from Drivana Cloud Functions!"

# Route for calculating surge pricing
@functions_framework.http
def calculate_surge_pricing(request):
    return calculate_surge(request)

# Route for creating a booking
@functions_framework.http
def create_new_booking(request):
    return create_booking(request)

# Route for updating booking status
@functions_framework.http
def update_booking(request):
    return update_booking_status(request)

# Route for processing payments
@functions_framework.http
def process_payment_request(request):
    return process_payment(request)

# Route for uploading car images
@functions_framework.http
def upload_image(request):
    return upload_car_image(request)

# Route for car recommendations using Gemini API
@functions_framework.http
def recommend_cars_endpoint(request):
    return recommend_cars(request)