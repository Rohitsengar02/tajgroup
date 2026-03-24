const Challan = require('../models/Challan');

exports.getChallans = async (req, res) => {
  try {
    const list = await Challan.find({}).sort({ createdAt: -1 });
    res.json(list);
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.createChallan = async (req, res) => {
  try {
    const c = new Challan(req.body);
    const saved = await c.save();
    res.status(201).json(saved);
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.updateChallan = async (req, res) => {
  try {
    const updated = await Challan.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.deleteChallan = async (req, res) => {
  try {
    await Challan.findByIdAndDelete(req.params.id);
    res.json({ message: 'Deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};
