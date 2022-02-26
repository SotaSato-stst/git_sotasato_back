require('dotenv').config()

module.exports = {
  apiBaseUrl: 'https://api.hojokin-dock.com',
  apiKey: process.env.PRODUCTION_API_KEY,
  authDomain: process.env.PRODUCTION_AUTH_DOMAIN,
  projectId: process.env.PRODUCTION_PROJECT_ID,
  storageBucket: process.env.PRODUCTION_STORAGE_BUCKET,
  messagingSenderId: process.env.PRODUCTION_MESSAGING_SNDER_ID,
  appId: process.env.PRODUCTION_APP_ID,
  measurementId: process.env.PRODUCTION_MEASUREMENT_ID,
}
