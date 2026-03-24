const express = require('express');
const router = express.Router();
const { getChallans, createChallan, updateChallan, deleteChallan } = require('../controllers/challanController');

router.route('/').get(getChallans).post(createChallan);
router.route('/:id').put(updateChallan).delete(deleteChallan);

module.exports = router;
