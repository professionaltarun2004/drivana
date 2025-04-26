from firebase_admin import firestore
import firebase_admin
from datetime import datetime

# Initialize Firebase Admin
if not firebase_admin._apps:
    firebase_admin.initialize_app()

db = firestore.client()

def process_payment(request):
    """Process a payment for a booking."""
    try:
        request_json = request.get_json()
        required_fields = ["bookingId", "userId", "amount", "method"]
        if not request_json or not all(field in request_json for field in required_fields):
            return {"error": "Missing required fields"}, 400

        booking_id = request_json["bookingId"]
        user_id = request_json["userId"]
        amount = float(request_json["amount"])  # Amount in rupees
        method = request_json["method"]

        # Validate booking
        booking_ref = db.collection("bookings").document(booking_id)
        booking = booking_ref.get()
        if not booking.exists:
            return {"error": "Booking not found"}, 404

        # Create payment record
        payment_data = {
            "bookingId": booking_id,
            "userId": user_id,
            "amount": amount,
            "method": method,
            "status": "pending",
            "createdAt": firestore.SERVER_TIMESTAMP
        }

        if method == "Cash":
            # For Cash, mark as pending (requires manual confirmation by admin or driver)
            payment_ref = db.collection("payments").document()
            payment_data["status"] = "pending"
            payment_ref.set(payment_data)
            return {"paymentId": payment_ref.id, "status": "pending", "method": "Cash"}, 200
        else:
            # For UPI or Others, simulate a successful payment (mock implementation)
            # In a real app, this would call a payment gateway API (e.g., Stripe, Paytm)
            payment_ref = db.collection("payments").document()
            payment_data["status"] = "completed"  # Simulate success
            payment_data["transactionId"] = f"mock_txn_{payment_ref.id}"  # Mock transaction ID
            payment_ref.set(payment_data)

            # Update booking status to confirmed after payment
            booking_ref.update({"status": "confirmed"})

            return {
                "paymentId": payment_ref.id,
                "status": "completed",
                "method": method,
                "amount": amount,
                "transactionId": payment_data["transactionId"]
            }, 200
    except Exception as e:
        return {"error": str(e)}, 500