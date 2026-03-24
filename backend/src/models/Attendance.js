const mongoose = require('mongoose');

const attendanceSchema = mongoose.Schema({
  member: { type: mongoose.Schema.Types.ObjectId, ref: 'TeamMember', required: true },
  date: { type: String, required: true }, // Store as YYYY-MM-DD
  status: { type: String, enum: ['Present', 'Absent', 'On Leave'], required: true, default: 'Absent' }
}, { timestamps: true });

// Enforcing one attendance record per team member per day
attendanceSchema.index({ member: 1, date: 1 }, { unique: true });

module.exports = mongoose.model('Attendance', attendanceSchema);
