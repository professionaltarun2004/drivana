from firebase_admin import firestore
import firebase_admin
from datetime import datetime

# Initialize Firebase Admin
if not firebase_admin._apps:
    firebase_admin.initialize_app()

db = firestore.client()

def create_booking(request):
    """Create a new booking."""
    try:
        request_json = request.get_json()
        required_fields = ["userId", "carId", "pickupDate", "duration"]
        if not request_json or not all(field in request_json for field in required_fields):
            return {"error": "Missing required fields"}, 400

        user_id = request_json["userId"]
        car_id = request_json["carId"]
        pickup_date = datetime.fromisoformat(request_json["pickupDate"])
        duration = int(request_json["duration"])

        # Check car availability
        car_ref = db.collection("cars").document(car_id)
        car = car_ref.get()
        if not car.exists or not car.to_dict().get("availability", True):
            return {"error": "Car not available"}, 400

        # Calculate total price (basePrice * surgeMultiplier * duration)
        car_data = car.to_dict()
        base_price = car_data.get("basePrice", 2000)
        surge_multiplier = car_data.get("surgeMultiplier", 1.0)
        total_price = base_price * surge_multiplier * duration

        # Create booking
        booking_data = {
            "userId": user_id,
            "carId": car_id,
            "pickupDate": pickup_date,
            "duration": duration,
            "totalPrice": total_price,
            "status": "pending",
            "city": car_data.get("city", "Unknown"),
            "createdAt": datetime.now()
        }
        booking_ref = db.collection("bookings").document()
        booking_ref.set(booking_data)

        # Update car availability
        car_ref.update({"availability": False})

        return {"bookingId": booking_ref.id, "totalPrice": total_price}, 200
    except Exception as e:
        return {"error": str(e)}, 500

def update_booking_status(request):
    """Update the status of a booking."""
    try:
        request_json = request.get_json()
        if not request_json or "bookingId" not in request_json or "status" not in request_json:
            return {"error": "Booking ID and status are required"}, 400

        booking_id = request_json["bookingId"]
        new_status = request_json["status"]

        # Validate status
        valid_statuses = ["pending", "confirmed", "completed", "canceled"]
        if new_status not in valid_statuses:
            return {"error": "Invalid status"}, 400

        # Update booking status
        booking_ref = db.collection("bookings").document(booking_id)
        booking = booking_ref.get()
        if not booking.exists:
            return {"error": "Booking not found"}, 404

        booking_ref.update({"status": new_status})

        # If status is "canceled" or "completed", make the car available again
        if new_status in ["canceled", "completed"]:
            booking_data = booking.to_dict()
            car_id = booking_data["carId"]
            car_ref = db.collection("cars").document(car_id)
            car_ref.update({"availability": True})

        return {"message": f"Booking {booking_id} updated to {new_status}"}, 200
    except Exception as e:
        return {"error": str(e)}, 500