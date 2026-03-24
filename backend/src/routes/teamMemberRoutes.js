const express = require('express');
const router = express.Router();
const {
  getTeamMembers,
  getTeamMemberById,
  createTeamMember,
  updateTeamMember,
  deleteTeamMember,
} = require('../controllers/teamMemberController');

router.route('/').get(getTeamMembers).post(createTeamMember);
router.route('/:id').get(getTeamMemberById).put(updateTeamMember).delete(deleteTeamMember);

module.exports = router;
