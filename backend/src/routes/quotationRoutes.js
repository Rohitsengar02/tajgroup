const express = require('express');
const { createQuotation, getQuotations, getQuotationById, updateQuotationStatus } = require('../controllers/quotationController');

const router = express.Router();

router.post('/', createQuotation);
router.get('/', getQuotations);
router.get('/:id', getQuotationById);
router.put('/:id/status', updateQuotationStatus);

module.exports = router;
