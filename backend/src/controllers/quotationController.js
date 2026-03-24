const Quotation = require('../models/Quotation');

const createQuotation = async (req, res) => {
  try {
    const quotation = new Quotation(req.body);
    const createdQuotation = await quotation.save();
    res.status(201).json(createdQuotation);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getQuotations = async (req, res) => {
  try {
    const quotations = await Quotation.find({}).sort({ createdAt: -1 });
    res.json(quotations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getQuotationById = async (req, res) => {
  try {
    const quotation = await Quotation.findById(req.params.id);
    if (quotation) {
      res.json(quotation);
    } else {
      res.status(404).json({ message: 'Quotation not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const updateQuotationStatus = async (req, res) => {
  try {
    const quotation = await Quotation.findById(req.params.id);
    if (quotation) {
      quotation.status = req.body.status || quotation.status;
      const updatedQuotation = await quotation.save();
      res.json(updatedQuotation);
    } else {
      res.status(404).json({ message: 'Quotation not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { createQuotation, getQuotations, getQuotationById, updateQuotationStatus };
