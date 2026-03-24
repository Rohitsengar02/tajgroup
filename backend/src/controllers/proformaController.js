const Proforma = require('../models/Proforma');

exports.getProformas = async (req, res) => {
  try {
    const list = await Proforma.find({}).sort({ createdAt: -1 });
    res.json(list);
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.createProforma = async (req, res) => {
  try {
    const p = new Proforma(req.body);
    const saved = await p.save();
    res.status(201).json(saved);
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.updateProforma = async (req, res) => {
  try {
    const updated = await Proforma.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.deleteProforma = async (req, res) => {
  try {
    await Proforma.findByIdAndDelete(req.params.id);
    res.json({ message: 'Deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};
