const Attendance = require('../models/Attendance');
const TeamMember = require('../models/TeamMember');

// @desc    Get all daily attendance combined with team members
// @route   GET /api/attendance/daily?date=YYYY-MM-DD
// @access  Public
const getDailyAttendance = async (req, res) => {
  try {
    const { date } = req.query;
    if (!date) {
      return res.status(400).json({ message: 'Date parameter is required (YYYY-MM-DD)' });
    }

    // Fetch all active team members
    const members = await TeamMember.find({ isActive: true });
    
    // Fetch today's attendance records
    const attendances = await Attendance.find({ date });

    // Combine them
    const combined = members.map(member => {
      const record = attendances.find(a => a.member.toString() === member._id.toString());
      return {
        memberId: member._id,
        name: member.name,
        territory: member.territory || 'Unassigned',
        status: record ? record.status : 'Absent' // Default to absent if not explicitly marked
      };
    });

    res.json(combined);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// @desc    Update a member's attendance
// @route   POST /api/attendance/update
// @access  Public
const updateAttendance = async (req, res) => {
  try {
    const { memberId, date, status } = req.body;

    if (!memberId || !date || !status) {
      return res.status(400).json({ message: 'memberId, date, and status are required' });
    }

    // Upsert the daily record
    const updated = await Attendance.findOneAndUpdate(
      { member: memberId, date: date },
      { $set: { status: status } },
      { new: true, upsert: true, setDefaultsOnInsert: true, runValidators: true }
    );

    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

module.exports = {
  getDailyAttendance,
  updateAttendance
};
