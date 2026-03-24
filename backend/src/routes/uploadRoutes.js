const express = require('express');
const router = express.Router();

// This is a simple endpoint that could be enhanced with Multer for file uploads
// For now, let's keep it minimal as requested, focusing on providing keys to the frontend
router.get('/config', (req, res) => {
  res.json({
    cloudName: process.env.CLOUDINARY_CLOUD_NAME,
    apiKey: process.env.CLOUDINARY_API_KEY,
    apiSecret: process.env.CLOUDINARY_API_SECRET,
    uploadPreset: process.env.CLOUDINARY_UPLOAD_PRESET,
  });
});

module.exports = router;
