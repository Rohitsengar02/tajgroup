const Scheme = require('../models/Scheme');

// @desc    Get all schemes
// @route   GET /api/schemes
const getSchemes = async (req, res) => {
  try {
    const schemes = await Scheme.find({}).sort({ createdAt: -1 });
    res.json(schemes);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// @desc    Create a scheme
// @route   POST /api/schemes
const createScheme = async (req, res) => {
  try {
    const { title, type, status, products, discountValue, startDate, endDate, imageUrl } = req.body;
    
    if(!title || !type || !products || !discountValue || !startDate || !endDate) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const scheme = new Scheme({
      title,
      type,
      status: status || "Active",
      products,
      discountValue,
      startDate,
      endDate,
      imageUrl: imageUrl || ""
    });

    const savedScheme = await scheme.save();
    res.status(201).json(savedScheme);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// @desc    Update a scheme
// @route   PUT /api/schemes/:id
const updateScheme = async (req, res) => {
  try {
    const { title, type, status, products, discountValue, startDate, endDate, imageUrl } = req.body;
    
    // Note: We might allow partial updates, but expecting all fields in the flutter form.
    const scheme = await Scheme.findById(req.params.id);
    if (!scheme) {
      return res.status(404).json({ message: 'Scheme not found' });
    }

    scheme.title = title || scheme.title;
    scheme.type = type || scheme.type;
    scheme.status = status || scheme.status;
    scheme.products = products || scheme.products;
    scheme.discountValue = discountValue || scheme.discountValue;
    scheme.startDate = startDate || scheme.startDate;
    scheme.endDate = endDate || scheme.endDate;
    if (imageUrl) {
      scheme.imageUrl = imageUrl;
    }

    const updatedScheme = await scheme.save();
    res.json(updatedScheme);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// @desc    Delete a scheme
// @route   DELETE /api/schemes/:id
const deleteScheme = async (req, res) => {
  try {
    const scheme = await Scheme.findByIdAndDelete(req.params.id);
    if (!scheme) return res.status(404).json({ message: 'Scheme not found' });
    res.json({ message: 'Scheme deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

module.exports = {
  getSchemes,
  createScheme,
  updateScheme,
  deleteScheme
};
