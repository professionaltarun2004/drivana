from firebase_admin import storage, firestore
import firebase_admin

# Initialize Firebase Admin
if not firebase_admin._apps:
    firebase_admin.initialize_app()

db = firestore.client()
bucket = storage.bucket()

def upload_car_image(request):
    """Upload a car image to Firebase Storage and update Firestore."""
    try:
        # Note: For simplicity, this assumes the image is sent as a URL or base64 data.
        # In a real app, you'd handle file uploads via the frontend and pass the file path.
        request_json = request.get_json()
        if not request_json or "carId" not in request_json or "imageUrl" not in request_json:
            return {"error": "Car ID and image URL are required"}, 400

        car_id = request_json["carId"]
        image_url = request_json["imageUrl"]

        # Download the image (simplified; in practice, handle file uploads directly)
        import requests
        response = requests.get(image_url)
        if response.status_code != 200:
            return {"error": "Failed to download image"}, 400

        # Upload to Firebase Storage
        blob = bucket.blob(f"cars/{car_id}/image.jpg")
        blob.upload_from_string(response.content, content_type="image/jpeg")
        blob.make_public()

        # Update Firestore with the image URL
        car_ref = db.collection("cars").document(car_id)
        car_ref.update({"imagePath": blob.public_url})

        return {"message": f"Image uploaded for car {car_id}", "imageUrl": blob.public_url}, 200
    except Exception as e:
        return {"error": str(e)}, 500