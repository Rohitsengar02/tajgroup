const Distribution = require('../models/Distribution');

// @desc    Get all distributions
// @route   GET /api/distribution
// @access  Public
exports.getDistributions = async (req, res) => {
  try {
    const distributions = await Distribution.find().sort({ createdAt: -1 });
    res.json(distributions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Add new distribution
// @route   POST /api/distribution
// @access  Public
exports.addDistribution = async (req, res) => {
  const { driverName, vehicleNumber, route, status, totalOrders, completedOrders, eta } = req.body;
  
  // Calculate initials
  let initials = "";
  if (driverName) {
    initials = driverName.split(' ').map(n => n[0]).join('').toUpperCase().substring(0, 2);
  }

  // Calculate progress
  let progress = 0;
  if (totalOrders > 0) {
    progress = completedOrders / totalOrders;
  }

  try {
    const newDistribution = new Distribution({
      driverName,
      vehicleNumber,
      route,
      status,
      totalOrders,
      completedOrders,
      eta,
      initials,
      progress
    });
    
    const saved = await newDistribution.save();
    res.status(201).json(saved);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// @desc    Update distribution
// @route   PUT /api/distribution/:id
// @access  Public
exports.updateDistribution = async (req, res) => {
  try {
    const { totalOrders, completedOrders, driverName } = req.body;
    
    // Auto-update if data changed
    if (totalOrders !== undefined && completedOrders !== undefined) {
      req.body.progress = totalOrders > 0 ? (completedOrders / totalOrders) : 0;
    }
    
    if (driverName) {
      req.body.initials = driverName.split(' ').map(n => n[0]).join('').toUpperCase().substring(0, 2);
    }

    const updated = await Distribution.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updated);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// @desc    Delete distribution
// @route   DELETE /api/distribution/:id
// @access  Public
exports.deleteDistribution = async (req, res) => {
  try {
    await Distribution.findByIdAndDelete(req.params.id);
    res.json({ message: 'Distribution deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
