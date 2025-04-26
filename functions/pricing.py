from firebase_admin import firestore
import firebase_admin
from datetime import datetime

# Initialize Firebase Admin
if not firebase_admin._apps:
    firebase_admin.initialize_app()

db = firestore.client()

def calculate_surge(request):
    """Calculate surge pricing based on city, time, and demand."""
    try:
        # Get request data
        request_json = request.get_json()
        if not request_json or "city" not in request_json:
            return {"error": "City is required"}, 400

        city = request_json["city"]
        duration = request_json.get("duration", 1)  # Default to 1 day

        # Determine surge multiplier based on time (peak hours: 8-10 AM, 5-8 PM)
        current_hour = datetime.now().hour
        surge_multiplier = 1.0
        if 8 <= current_hour <= 10 or 17 <= current_hour <= 20:
            surge_multiplier = 1.2  # 20% increase during peak hours

        # Calculate demand-based surge (simplified: based on number of bookings in the city)
        bookings_ref = db.collection("bookings").where("city", "==", city).where("status", "==", "confirmed")
        recent_bookings = bookings_ref.where("pickupDate", ">=", datetime.now().timestamp() - 86400).get()
        booking_count = len(recent_bookings)
        if booking_count > 10:  # Increase surge if more than 10 bookings in the last 24 hours
            surge_multiplier += 0.1

        # Update all cars in the city with the new surge multiplier
        cars_ref = db.collection("cars").where("city", "==", city)
        cars = cars_ref.get()
        for car in cars:
            car_ref = db.collection("cars").document(car.id)
            car_ref.update({"surgeMultiplier": surge_multiplier})

        return {"city": city, "surgeMultiplier": surge_multiplier, "duration": duration}, 200
    except Exception as e:
        return {"error": str(e)}, 500