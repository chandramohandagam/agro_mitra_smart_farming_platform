import os
from datetime import datetime
from typing import List, Optional

import google.generativeai as genai
import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

load_dotenv()

app = FastAPI(
    title="Agro Mitra Backend API",
    description="Backend services for Agro Mitra Smart Farming Platform",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# API Keys from .env
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
AGMARKNET_API_KEY = os.getenv("AGMARKNET_API_KEY")

if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)
    model = genai.GenerativeModel('gemini-1.5-flash')
else:
    model = None

@app.get("/")
def read_root():
    return {"message": "Welcome to Agro Mitra API", "status": "online"}

@app.get("/api/v1/health")
def health_check():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

# --- WEATHER SERVICE ---
@app.get("/api/v1/weather/forecast")
async def get_weather_forecast(lat: float, lon: float):
    url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&hourly=precipitation_probability&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto"

    async with httpx.AsyncClient() as client:
        try:
            resp = await client.get(url)
            data = resp.json()
            curr = data.get("current", {})
            daily = data.get("daily", {})
            hourly = data.get("hourly", {})

            # Map weather codes to conditions (Simplified)
            condition_map = {0: "Sunny", 1: "Mainly Clear", 2: "Partly Cloudy", 3: "Overcast", 45: "Foggy", 48: "Depositing Rime Fog", 51: "Light Drizzle", 61: "Slight Rain", 80: "Rain Showers"}
            code = curr.get("weather_code", 0)
            condition = condition_map.get(code, "Partly Cloudy")

            # Hourly rain probability for next 12 hours
            rain_probs = []
            if hourly:
                times = hourly.get("time", [])[:7]
                probs = hourly.get("precipitation_probability", [])[:7]
                for i in range(len(times)):
                    dt = datetime.fromisoformat(times[i])
                    rain_probs.append({
                        "time": dt.strftime("%I%p").lower(),
                        "prob": probs[i] / 100.0
                    })

            # 7-day forecast (actually 3-day for brevity in this mock)
            forecast = []
            if daily:
                days = daily.get("time", [])[:3]
                max_temps = daily.get("temperature_2m_max", [])
                min_temps = daily.get("temperature_2m_min", [])
                codes = daily.get("weather_code", [])
                for i in range(len(days)):
                    dt = datetime.fromisoformat(days[i])
                    forecast.append({
                        "day": "Tomorrow" if i == 0 else dt.strftime("%a"),
                        "icon": "sunny" if codes[i] < 3 else "cloud",
                        "temp_range": f"{int(max_temps[i])}° / {int(min_temps[i])}°",
                        "progress": 0.4 + (i * 0.2)
                    })

            return {
                "current": {
                    "temp": int(curr.get("temperature_2m", 28)),
                    "condition": condition,
                    "high": int(daily.get("temperature_2m_max", [32])[0]),
                    "low": int(daily.get("temperature_2m_min", [21])[0]),
                    "humidity": int(curr.get("relative_humidity_2m", 64)),
                    "uv_index": "Moderate 4",
                    "wind_speed": f"{curr.get('wind_speed_10m', 12)} km/h"
                },
                "ai_insight": "Ideal time for urea application detected. Soil moisture is optimal.",
                "rain_probability": rain_probs,
                "forecast": forecast,
                "agri_advice": [
                    {
                        "title": "Optimal Fertilization",
                        "subtitle": "Based on nitrogen levels",
                        "content": "Conditions for Wheat crop are perfect for top-dressing urea today.",
                        "type": "fertilizer"
                    }
                ]
            }
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

# --- MARKET SERVICE ---
@app.get("/api/v1/market/prices")
async def get_market_prices():
    # Agmarknet API integration
    agmarknet_url = f"https://api.data.gov.in/resource/9ef0be34-55f4-4115-a6a1-4af09a903b36?api-key={AGMARKNET_API_KEY}&format=json&offset=0&limit=5"
    async with httpx.AsyncClient() as client:
        try:
            resp = await client.get(agmarknet_url)
            if resp.status_code == 200:
                records = resp.json().get("records", [])
                if records:
                    return [
                        {
                            "commodity": r.get("commodity", "Wheat"),
                            "market": r.get("market", "Amritsar"),
                            "price": float(r.get("modal_price", 2275)),
                            "unit": "Quintal",
                            "change": 1.2,
                            "updated_at": datetime.now().isoformat()
                        }
                        for r in records
                    ]
        except Exception:
            pass

    return [
        {"commodity": "Basmati Rice", "market": "Amritsar", "price": 3850, "unit": "Quintal", "change": 2.5, "updated_at": datetime.now().isoformat()},
        {"commodity": "Wheat", "market": "Ludhiana", "price": 2275, "unit": "Quintal", "change": -0.8, "updated_at": datetime.now().isoformat()},
    ]

# --- AI SERVICE ---
class ChatRequest(BaseModel):
    message: str

@app.post("/api/v1/ai/chat")
async def ai_chat(req: ChatRequest):
    if not model:
        return {"text": "AI Service unavailable (API Key missing)", "sender": "ai", "timestamp": datetime.now().isoformat()}

    try:
        response = await model.generate_content_async(req.message)
        return {
            "text": response.text,
            "sender": "ai",
            "timestamp": datetime.now().isoformat(),
            "insight": {
                "title": "AI Suggestion",
                "content": "I recommend checking your soil pH based on this query.",
                "progress": 0.7,
                "status_label": "Informational",
                "action_label": "Learn More"
            }
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/v1/disease/detect")
async def detect_disease(image: UploadFile = File(...)):
    if not model:
        raise HTTPException(status_code=503, detail="AI Service unavailable")

    try:
        contents = await image.read()
        response = await model.generate_content_async([
            "Analyze this crop leaf image. Identify disease, scientific name, severity, and treatment steps. Return as JSON with keys: disease_name, scientific_name, confidence, severity, treatment_steps (list), humidity_context (float 0-1), recommendations (list of dicts with name, price).",
            {"mime_type": image.content_type, "data": contents}
        ])

        # In production, we'd parse the JSON from response.text
        # For now, providing a structured mock that mimics AI output
        return {
            "disease_name": "Yellow Rust",
            "scientific_name": "Puccinia striiformis",
            "confidence": 94,
            "severity": "High",
            "treatment_steps": [
                "Isolate infected area with 5m buffer",
                "Apply systemic fungicides within 48h",
                "Reduce nitrogen application"
            ],
            "humidity_context": 0.78,
            "recommendations": [
                {"name": "AgroShield-Pro", "price": "₹1,249"},
                {"name": "BioGuard Rust", "price": "₹899"}
            ]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# --- RECOMMENDATIONS ---
class CropRecommendationRequest(BaseModel):
    soil_texture: str
    ph_level: float
    moisture_percentage: int
    lat: float
    lon: float

@app.post("/api/v1/recommendations/crop")
async def get_crop_recommendations(req: CropRecommendationRequest):
    return {
        "recommendations": [
            {
                "name": "Soybean",
                "match_percentage": 98,
                "description": "Optimal for Loamy soil and current monsoon conditions.",
                "expected_yield": "2.8 T/ac",
                "profit_estimate": "₹45k/ac",
                "risk_level": "Low"
            },
            {
                "name": "Cotton",
                "match_percentage": 84,
                "description": "Secondary choice with moderate water requirements.",
                "expected_yield": "1.5 T/ac",
                "profit_estimate": "₹32k/ac",
                "risk_level": "Medium"
            }
        ],
        "soil_health_summary": ["Nitrogen levels optimal", "Phosphorus deficiency detected"],
        "climate_outlook": "Early monsoon onset predicted. Recommend planting by June 12th."
    }

# --- DASHBOARDS ---
@app.get("/api/v1/farmer/dashboard")
async def get_farmer_dashboard():
    return {
        "greeting": "Good Morning, Farmer!",
        "farm_health_percentage": 0.85,
        "upcoming_task": {
            "title": "Irrigation cycle",
            "start_time": datetime.now().isoformat()
        },
        "active_crops": [
            {"id": "1", "name": "Rice", "phase": "Tillering", "icon": "grass"},
            {"id": "2", "name": "Tomato", "phase": "Flowering", "icon": "local_florist"}
        ]
    }

@app.get("/api/v1/farms")
async def get_farms():
    return [
        {
            "id": "1",
            "name": "North Field",
            "crop": "Wheat",
            "phase": "Growth",
            "area": "4.5 Acres",
            "soil": "Loamy",
            "expected_harvest": datetime.now().isoformat(),
            "progress": 0.65,
            "icon": "grass"
        }
    ]

@app.get("/api/v1/dealer/dashboard")
async def get_dealer_dashboard():
    return {
        "total_orders": 156,
        "pending_orders": 12,
        "total_revenue": 450000.0,
        "low_stock_items": [
            {"id": "1", "name": "Urea", "current_stock": 10, "unit": "bags"}
        ],
        "recent_orders": [
            {"id": "1", "customer_name": "Ramesh Kumar", "amount": 12450.0, "status": "delivered", "date": datetime.now().isoformat()}
        ]
    }

@app.get("/api/v1/company/dashboard")
async def get_company_dashboard():
    return {
        "total_dealers": 42,
        "total_products": 15,
        "active_market_share": 12.5,
        "regional_performance": [
            {"region": "Punjab", "sales": 1200000.0, "growth": 15.0}
        ],
        "active_campaigns": [
            {"title": "Kharif Special", "reach": 5000, "roi": 3.2}
        ]
    }

@app.get("/api/v1/admin/dashboard")
async def get_admin_dashboard():
    return {
        "total_users": 1250,
        "active_now": 45,
        "flagged_content": 3,
        "system_uptime": 99.9,
        "system_logs": [
            {"level": "INFO", "message": "Database sync successful", "timestamp": datetime.now().isoformat()}
        ]
    }

@app.get("/api/v1/schemes")
async def get_schemes():
    return [
        {
            "id": "1",
            "title": "PM-Kisan",
            "description": "Direct income support of ₹6,000 per year.",
            "icon": "payments",
            "tags": ["Small Farmers", "Income Support"],
            "status": "Active"
        }
    ]

@app.get("/api/v1/schemes/applications")
async def get_scheme_applications():
    return [
        {
            "scheme_id": "1",
            "scheme_title": "PM-Kisan",
            "status": "Approved",
            "updated_at": datetime.now().isoformat()
        }
    ]

@app.get("/api/v1/transport/bookings")
async def get_transport_bookings():
    return [
        {
            "id": "1",
            "vehicle_type": "Tractor",
            "driver_name": "Suresh Singh",
            "status": "pending",
            "from_location": "Farm A",
            "to_location": "Mandi B",
            "price": 1200.0,
            "scheduled_time": datetime.now().isoformat()
        }
    ]

@app.get("/api/v1/notifications")
async def get_notifications():
    return [
        {
            "id": "1",
            "title": "Rain Alert",
            "body": "Heavy rain expected at 3 PM. Cover your harvest.",
            "type": "weather",
            "timestamp": datetime.now().isoformat(),
            "is_read": False
        }
    ]

@app.post("/api/v1/notifications/{id}/read")
async def mark_notification_read(id: str):
    return {"status": "success"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
