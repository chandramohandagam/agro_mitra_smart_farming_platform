# Agro Mitra - Smart Farming Platform

Agro Mitra is a comprehensive smart farming solution designed to empower farmers, dealers, and agricultural companies through modern technology. The platform provides real-time data, AI-driven insights, and a seamless marketplace to optimize farming operations.

## 🚀 Key Features

### 👨‍🌾 For Farmers
*   **AI Health Check**: Instant crop disease detection using Gemini-powered image analysis.
*   **Smart Weather**: Real-time forecasts and localized agri-weather advice via Open-Meteo.
*   **Live Mandi Prices**: Real-time market price tracking from AGMARKNET.
*   **Crop & Fertilizer Advice**: Personalized recommendations based on soil health and location.
*   **Field Management**: Digital tracking of multiple fields and growth stages.
*   **Agro Mitra AI**: 24/7 intelligent assistant for farming queries.

### 🏪 For Dealers & Companies
*   **Inventory Management**: Track stock levels and receive low-stock alerts.
*   **Business Analytics**: View regional performance and sales growth.
*   **Marketing ROI**: Monitor campaign reach and effectiveness.
*   **Order Tracking**: Manage customer orders and local logistics.

### 🛡️ For Admins
*   **System Health**: Real-time monitoring of user activity and system uptime.
*   **Content Moderation**: Centralized management of flagged community content.

## 🏗️ Architecture

The platform follows a robust full-stack architecture:

*   **Frontend**: Flutter (Android & iOS)
    *   State Management: Provider
    *   Networking: Dio with JWT interceptors
    *   Design: Stitch UI (Glassmorphism, 24px radius, Nature Green palette)
*   **Backend**: FastAPI (Python)
    *   Security: Secure gateway for external APIs
    *   Deployment: Render/Production-ready
*   **Database & Auth**: Supabase (PostgreSQL)
*   **External Integrations**:
    *   **Gemini 1.5 Flash**: AI chat and vision analysis
    *   **Open-Meteo**: Weather data
    *   **AGMARKNET**: Market prices
    *   **OpenStreetMap**: Field mapping

## 🛠️ Setup Instructions

### Backend (FastAPI)
1.  Navigate to `agro_mitra_backend/`.
2.  Install dependencies: `pip install -r requirements.txt`.
3.  Create a `.env` file based on `.env.example`.
4.  Run the server: `python main.py`.

### Frontend (Flutter)
1.  Navigate to `agro_mitra_app/`.
2.  Install dependencies: `flutter pub get`.
3.  Create a `.env` file in the app root with `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `BACKEND_URL`.
4.  Run the app: `flutter run`.

## 🔒 Security
*   No sensitive API keys (Gemini, Agmarknet) are stored in the Flutter app.
*   FastAPI acts as a secure proxy, injecting keys only on the server side.
*   Automatic JWT token refresh and secure session management.

## 📝 License
Proprietary - Developed for the Agro Mitra Smart Farming Initiative.
