const mongoose = require('mongoose');

const orderSchema = mongoose.Schema(
  {
    orderId: {
      type: String,
      required: true,
      unique: true,
    },
    orderType: { type: String, enum: ['Secondary', 'Primary'], default: 'Secondary' },
    salesPerson: { type: String },
    paymentType: { type: String, enum: ['Credit', 'Cash', 'Online'], default: 'Cash' },
    godown: { type: String },
    billingName: { type: String },
    billingAddress: { type: String },
    shippingAddress: { type: String },
    poNo: { type: String },
    poDate: { type: Date },
    ewayBillNo: { type: String },
    invoiceNumber: { type: String },
    invoiceDate: { type: Date },
    time: { type: String },
    stateOfSupply: { type: String },
    description: { type: String },
    deliveryLocation: { type: String },
    attachments: [{ type: String }], // Cloudinary URLs
    items: [
      {
        productName: { type: String, required: true },
        batchNo: { type: String },
        expiryDate: { type: String },
        mrp: { type: Number },
        quantity: { type: Number, required: true },
        unit: { type: String, default: 'PC!' },
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
      enum: ['Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered', 'Cancelled'],
      default: 'Pending',
    },
    paymentStatus: {
      type: String,
      required: true,
      enum: ['Paid', 'Unpaid', 'Partial'],
      default: 'Unpaid',
    },
    createdBy: {
      type: String, // Email or UID of the user who created it
      required: true,
    },
    orderDate: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  }
);

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;
