import {initializeApp} from 'firebase/app'
import {getAnalytics} from 'firebase/analytics'
const environment = process.env.NODE_ENV || 'development'
const envSet = require(`./../environments/${environment}.ts`)

const firebaseConfig = {
  apiKey: envSet.apiKey,
  authDomain: envSet.authDomain,
  projectId: envSet.projectId,
  storageBucket: envSet.storageBucket,
  messagingSenderId: envSet.messagingSenderId,
  appId: envSet.appId,
  measurementId: envSet.measurementId,
}

const app = initializeApp(firebaseConfig)
if (environment === 'production') {
  getAnalytics(app)
}
