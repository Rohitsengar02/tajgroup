const admin = require('firebase-admin');
require('dotenv').config();

// Note: For full functionality, you should download your serviceAccountKey.json 
// from Firebase Console and place it in backend/src/config/
try {
  const serviceAccount = require('./serviceAccountKey.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  console.log('Firebase Admin Initialized');
} catch (error) {
  console.warn('Firebase Admin Service Account not found. Falling back to public config if possible (limited functionality).');
  // Fallback or handle appropriately. admin.initializeApp() without cert will fail on local.
}

module.exports = admin;
