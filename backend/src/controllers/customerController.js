const Customer = require('../models/Customer');

// @desc    Get all customers
// @route   GET /api/customers
// @access  Public
const getCustomers = async (req, res) => {
  try {
    const customers = await Customer.find({});
    res.json(customers);
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

// @desc    Get customer by ID
// @route   GET /api/customers/:id
// @access  Public
const getCustomerById = async (req, res) => {
  try {
    const customer = await Customer.findById(req.params.id);
    if (customer) {
      res.json(customer);
    } else {
      res.status(404).json({ message: 'Customer not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

// @desc    Create a customer
// @route   POST /api/customers
// @access  Public
const createCustomer = async (req, res) => {
  try {
    const {
      customerId,
      customerName,
      shopOwnerName,
      shopName,
      gstNumber,
      shopAddress,
      townCity,
      territory,
      phoneNumber,
      mobileNumber,
      email,
      beat,
      assignedSalesman,
      assignedDistributor,
      preferredProducts,
      creditLimit,
      isActive,
      notes,
      customerType,
      outstandingBalance,
      lastVisit
    } = req.body;

    const customerExists = await Customer.findOne({ customerId });

    if (customerExists) {
      return res.status(400).json({ message: 'Customer already exists' });
    }

    const customer = await Customer.create({
      customerId,
      customerName,
      shopOwnerName,
      shopName,
      gstNumber,
      shopAddress,
      townCity,
      territory,
      phoneNumber,
      mobileNumber,
      email,
      beat,
      assignedSalesman,
      assignedDistributor,
      preferredProducts,
      creditLimit,
      isActive,
      notes,
      customerType,
      outstandingBalance,
      lastVisit
    });

    if (customer) {
      res.status(201).json(customer);
    } else {
      res.status(400).json({ message: 'Invalid customer data' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// @desc    Update a customer
// @route   PUT /api/customers/:id
// @access  Public
const updateCustomer = async (req, res) => {
  try {
    const customer = await Customer.findById(req.params.id);

    if (customer) {
      customer.customerName = req.body.customerName || customer.customerName;
      customer.shopOwnerName = req.body.shopOwnerName || customer.shopOwnerName;
      customer.shopName = req.body.shopName || customer.shopName;
      customer.gstNumber = req.body.gstNumber || customer.gstNumber;
      customer.shopAddress = req.body.shopAddress || customer.shopAddress;
      customer.townCity = req.body.townCity || customer.townCity;
      customer.territory = req.body.territory || customer.territory;
      customer.phoneNumber = req.body.phoneNumber || customer.phoneNumber;
      customer.mobileNumber = req.body.mobileNumber || customer.mobileNumber;
      customer.email = req.body.email || customer.email;
      customer.beat = req.body.beat || customer.beat;
      customer.assignedSalesman = req.body.assignedSalesman || customer.assignedSalesman;
      customer.assignedDistributor = req.body.assignedDistributor || customer.assignedDistributor;
      customer.preferredProducts = req.body.preferredProducts || customer.preferredProducts;
      customer.creditLimit = req.body.creditLimit !== undefined ? req.body.creditLimit : customer.creditLimit;
      customer.isActive = req.body.isActive !== undefined ? req.body.isActive : customer.isActive;
      customer.notes = req.body.notes || customer.notes;
      customer.customerType = req.body.customerType || customer.customerType;
      customer.outstandingBalance = req.body.outstandingBalance !== undefined ? req.body.outstandingBalance : customer.outstandingBalance;
      customer.lastVisit = req.body.lastVisit || customer.lastVisit;

      const updatedCustomer = await customer.save();
      res.json(updatedCustomer);
    } else {
      res.status(404).json({ message: 'Customer not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

// @desc    Delete a customer
// @route   DELETE /api/customers/:id
// @access  Public
const deleteCustomer = async (req, res) => {
  try {
    const customer = await Customer.findById(req.params.id);

    if (customer) {
      await Customer.deleteOne({ _id: customer._id });
      res.json({ message: 'Customer removed' });
    } else {
      res.status(404).json({ message: 'Customer not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

module.exports = {
  getCustomers,
  getCustomerById,
  createCustomer,
  updateCustomer,
  deleteCustomer
};
