const express = require('express');
const router = express.Router();
const {
  getDailyAttendance,
  updateAttendance
} = require('../controllers/attendanceController');

router.get('/daily', getDailyAttendance);
router.post('/update', updateAttendance);

module.exports = router;
