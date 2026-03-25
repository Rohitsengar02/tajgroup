const SalesReturn = require('../models/SalesReturn');

// @desc    Get all sales returns
// @route   GET /api/returns
// @access  Public
exports.getReturns = async (req, res) => {
  try {
    const returns = await SalesReturn.find().sort({ createdAt: -1 });
    res.json(returns);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Add new sales return
// @route   POST /api/returns
// @access  Public
exports.addReturn = async (req, res) => {
  const { customerName, items, reason, status, notes } = req.body;
  
  // Simple ID generation for demo/now
  const returnId = 'RT-' + Math.floor(1000 + Math.random() * 9000);

  try {
    const newReturn = new SalesReturn({
      returnId,
      customerName,
      items,
      reason,
      status,
      notes
    });
    
    const saved = await newReturn.save();
    res.status(201).json(saved);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// @desc    Update sales return status
// @route   PUT /api/returns/:id
// @access  Public
exports.updateReturn = async (req, res) => {
  try {
    const updated = await SalesReturn.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updated);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// @desc    Delete sales return
// @route   DELETE /api/returns/:id
// @access  Public
exports.deleteReturn = async (req, res) => {
  try {
    await SalesReturn.findByIdAndDelete(req.params.id);
    res.json({ message: 'Return record deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
