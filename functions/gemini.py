import os
import requests
from dotenv import load_dotenv

# Load environment variables from .env for local testing
load_dotenv()

# Get the Gemini API key from environment variables
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY") or os.getenv("FUNCTIONS_CONFIG_GEMINI_API_KEY")

def recommend_cars(request):
    """Recommend cars using the Gemini API."""
    try:
        # Validate request data
        request_json = request.get_json()
        if not request_json or "city" not in request_json:
            return {"error": "City is required"}, 400

        city = request_json["city"]
        preferences = request_json.get("preferences", "SUV")

        # Check if API key is available
        if not GEMINI_API_KEY:
            return {"error": "Gemini API key not configured"}, 500

        # Gemini API endpoint (using Google AI Studio's REST API)
        endpoint = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key={GEMINI_API_KEY}"

        # Prepare the prompt
        prompt = f"Recommend cars for {city}, preferring {preferences}"
        payload = {
            "contents": [
                {
                    "parts": [
                        {"text": prompt}
                    ]
                }
            ]
        }

        # Make the API request
        headers = {"Content-Type": "application/json"}
        response = requests.post(endpoint, json=payload, headers=headers)

        if response.status_code != 200:
            return {"error": "Failed to call Gemini API", "details": response.text}, 500

        # Parse the response
        result = response.json()
        recommendations = result.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text", "No recommendations found")

        return {"recommendations": recommendations}, 200
    except Exception as e:
        return {"error": str(e)}, 500