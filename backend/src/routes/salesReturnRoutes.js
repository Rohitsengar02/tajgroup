const express = require('express');
const { getReturns, addReturn, updateReturn, deleteReturn } = require('../controllers/salesReturnController');

const router = express.Router();

router.get('/', getReturns);
router.post('/', addReturn);
router.put('/:id', updateReturn);
router.delete('/:id', deleteReturn);

module.exports = router;
