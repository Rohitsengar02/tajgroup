const mongoose = require('mongoose');

const customerSchema = mongoose.Schema(
  {
    customerId: { type: String, required: true, unique: true },
    customerName: { type: String, required: true },
    shopOwnerName: { type: String },
    shopName: { type: String, required: true },
    gstNumber: { type: String },
    shopAddress: { type: String },
    townCity: { type: String },
    territory: { type: String },
    phoneNumber: { type: String, required: true },
    mobileNumber: { type: String },
    email: { type: String },
    beat: { type: String },
    assignedSalesman: { type: String },
    assignedDistributor: { type: String },
    preferredProducts: [{ type: String }],
    creditLimit: { type: Number, default: 0 },
    isActive: { type: Boolean, default: true },
    notes: { type: String },
    customerType: { 
      type: String, 
      enum: ['Retailer', 'Wholesaler', 'Distributor'],
      default: 'Retailer'
    },
    outstandingBalance: { type: Number, default: 0 },
    lastVisit: { type: Date }
  },
  {
    timestamps: true,
  }
);

const Customer = mongoose.model('Customer', customerSchema);

module.exports = Customer;
