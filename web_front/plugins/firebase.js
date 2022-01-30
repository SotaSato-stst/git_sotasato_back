import {initializeApp} from 'firebase/app'
require('dotenv').config()

const firebaseConfig = {
  apiKey: process.env.API_KEY,
  authDomain: process.env.AUTH_DOMAIN,
  projectId: process.env.PROJECT_ID,
  storageBucket: process.env.STORAGE_BUCKET,
  messagingSenderId: process.env.MESSAGING_SNDER_ID,
  appId: process.env.APP_ID,
}

initializeApp(firebaseConfig)
