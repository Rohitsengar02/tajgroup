const Models = require('../models/User');
const jwt = require('jsonwebtoken');

const getModelByRole = (role) => {
  switch (role) {
    case 'Admin': return Models.Admin;
    case 'Super Stockist': return Models.SuperStockist;
    case 'Distributor': return Models.Distributor;
    case 'Sales Person': return Models.SalesPerson;
    case 'Retailer': return Models.Retailer;
    default: return null;
  }
};

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET || 'tajpro_secret_123', {
    expiresIn: '30d',
  });
};

// @desc    Auth user & get token
// @route   POST /api/auth/login
// @access  Public
const authUser = async (req, res) => {
  const { email, password, role } = req.body;

  if (!role) {
    return res.status(400).json({ message: 'Role is required' });
  }

  const Model = getModelByRole(role);
  if (!Model) {
    return res.status(400).json({ message: 'Invalid role provided' });
  }

  const user = await Model.findOne({ email });

  if (user && (await user.matchPassword(password))) {
    res.json({
      _id: user._id,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
      token: generateToken(user._id),
    });
  } else {
    res.status(401).json({ message: 'Invalid email or password' });
  }
};

// @desc    Register a new user
// @route   POST /api/auth/register
// @access  Public
const registerUser = async (req, res) => {
  const { fullName, email, password, role } = req.body;

  if (!role) {
    return res.status(400).json({ message: 'Role is required' });
  }

  const Model = getModelByRole(role);
  if (!Model) {
    return res.status(400).json({ message: 'Invalid role provided' });
  }

  const userExists = await Model.findOne({ email });

  if (userExists) {
    res.status(400).json({ message: 'User already exists' });
    return;
  }

  const user = await Model.create({
    fullName,
    email,
    password,
    role,
  });

  if (user) {
    res.status(201).json({
      _id: user._id,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
      token: generateToken(user._id),
    });
  } else {
    res.status(400).json({ message: 'Invalid user data' });
  }
};

module.exports = { authUser, registerUser };
