const mongoose = require('mongoose');

const quotationSchema = mongoose.Schema(
  {
    quotationId: {
      type: String,
      required: true,
      unique: true,
    },
    quotationType: { type: String, enum: ['Standard', 'Urgent'], default: 'Standard' },
    customerName: { type: String, required: true },
    salesPerson: { type: String },
    paymentType: { type: String, enum: ['Credit', 'Cash', 'Online'], default: 'Cash' },
    godown: { type: String },
    validUntil: { type: Date },
    billingName: { type: String },
    billingAddress: { type: String },
    shippingAddress: { type: String },
    description: { type: String },
    stateOfSupply: { type: String },
    deliveryLocation: { type: String },
    poNo: { type: String },
    poDate: { type: Date },
    time: { type: String },
    attachments: [{ type: String }],
    items: [
      {
        productName: { type: String, required: true },
        batchNo: { type: String },
        expiryDate: { type: String },
        mrp: { type: Number },
        quantity: { type: Number, required: true },
        unit: { type: String, default: 'PC' },
        price: { type: Number, required: true },
        discount: { type: Number, default: 0 },
        tax: { type: Number, default: 0 },
        amount: { type: Number, required: true },
      }
    ],
    totalAmount: { type: Number, required: true },
    discountPercentage: { type: Number, default: 0 },
    shippingCharges: { type: Number, default: 0 },
    packagingCharges: { type: Number, default: 0 },
    adjustment: { type: Number, default: 0 },
    status: {
      type: String,
      required: true,
      enum: ['Draft', 'Sent', 'Accepted', 'Rejected', 'Expired', 'Converted'],
      default: 'Draft',
    },
    createdBy: {
      type: String,
      required: true,
    },
    quotationDate: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  }
);

const Quotation = mongoose.model('Quotation', quotationSchema);

module.exports = Quotation;
