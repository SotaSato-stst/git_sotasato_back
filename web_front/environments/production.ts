require('dotenv').config()

module.exports = {
  apiBaseUrl: 'https://macro-market-336309.an.r.appspot.com',
  apiKey: process.env.PRODUCTION_API_KEY,
  authDomain: process.env.PRODUCTION_AUTH_DOMAIN,
  projectId: process.env.PRODUCTION_PROJECT_ID,
  storageBucket: process.env.PRODUCTION_STORAGE_BUCKET,
  messagingSenderId: process.env.PRODUCTION_MESSAGING_SNDER_ID,
  appId: process.env.PRODUCTION_APP_ID,
}
