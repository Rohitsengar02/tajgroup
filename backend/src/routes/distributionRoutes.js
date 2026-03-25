const express = require('express');
const { getDistributions, addDistribution, updateDistribution, deleteDistribution } = require('../controllers/distributionController');

const router = express.Router();

router.get('/', getDistributions);
router.post('/', addDistribution);
router.put('/:id', updateDistribution);
router.delete('/:id', deleteDistribution);

module.exports = router;
