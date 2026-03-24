const express = require('express');
const router = express.Router();
const { getProformas, createProforma, updateProforma, deleteProforma } = require('../controllers/proformaController');

router.route('/').get(getProformas).post(createProforma);
router.route('/:id').put(updateProforma).delete(deleteProforma);

module.exports = router;
