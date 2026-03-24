const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const baseUserSchema = {
  fullName: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, required: true },
  firebaseUid: { type: String },
  phone: { type: String },
  status: { type: String, default: 'Active' },
};

const options = { timestamps: true };

const createModel = (name, collection) => {
  const schema = new mongoose.Schema(baseUserSchema, options);
  
  schema.methods.matchPassword = async function (enteredPassword) {
    return await bcrypt.compare(enteredPassword, this.password);
  };

  schema.pre('save', async function (next) {
    if (!this.isModified('password')) return next();
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
  });

  return mongoose.model(name, schema, collection);
};

module.exports = {
  Admin: createModel('Admin', 'admins'),
  SuperStockist: createModel('SuperStockist', 'super_stockists'),
  Distributor: createModel('Distributor', 'distributors'),
  SalesPerson: createModel('SalesPerson', 'sales_persons'),
  Retailer: createModel('Retailer', 'retailers'),
};
