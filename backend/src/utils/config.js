const path = require("path");

const backendRoot = path.resolve(__dirname, "..", "..");

function parseAllowedOrigins() {
  const raw =
    process.env.FRONTEND_ORIGINS ||
    process.env.FRONTEND_ORIGIN ||
    "";

  return raw
    .split(",")
    .map((origin) => origin.trim())
    .filter(Boolean);
}

function getConfig() {
  const isRender = process.env.RENDER === "true";
  const mlServiceUrl =
    process.env.ML_SERVICE_URL ||
    (process.env.ML_SERVICE_HOSTPORT ? `http://${process.env.ML_SERVICE_HOSTPORT}` : "http://127.0.0.1:8000");
  return {
    backendRoot,
    host: process.env.HOST || (isRender ? "0.0.0.0" : "127.0.0.1"),
    port: Number(process.env.PORT || 3000),
    nodeEnv: process.env.NODE_ENV || "development",
    jwtSecret: process.env.JWT_SECRET || "shiftshield-dev-secret",
    twilioAccountSid: process.env.TWILIO_ACCOUNT_SID || "",
    twilioAuthToken: process.env.TWILIO_AUTH_TOKEN || "",
    twilioVerifyServiceSid: process.env.TWILIO_VERIFY_SERVICE_SID || "",
    mlServiceUrl,
    openMeteoWeatherUrl:
      process.env.OPEN_METEO_WEATHER_URL || "https://api.open-meteo.com/v1/forecast",
    openMeteoAqiUrl:
      process.env.OPEN_METEO_AQI_URL || "https://air-quality-api.open-meteo.com/v1/air-quality",
    supabaseUrl: process.env.SUPABASE_URL || "",
    supabaseServiceKey: process.env.SUPABASE_SERVICE_KEY || "",
    allowedOrigins: parseAllowedOrigins(),
    localStorePath: path.join(backendRoot, "data", "local-db.json"),
    citiesSeedPath: path.join(backendRoot, "seed", "cities.json"),
    zonesSeedPath: path.join(backendRoot, "seed", "zones.json"),
    thresholdsSeedPath: path.join(backendRoot, "seed", "thresholds.json"),
    ridersSeedPath: path.join(backendRoot, "seed", "mock-riders.json")
  };
}

module.exports = {
  getConfig
};
