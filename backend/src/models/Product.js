const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  name: { type: String, required: true },
  sku: { type: String, required: true, unique: true },
  category: { type: String, required: true },
  brand: { type: String },
  unit: { type: String, default: 'PC' },
  price: { type: Number, required: true },
  mrp: { type: Number },
  costPrice: { type: Number },
  currentStock: { type: Number, default: 0 },
  minStockLevel: { type: Number, default: 0 },
  description: { type: String },
  images: [{ type: String }], // Cloudinary URLs
  status: { type: String, enum: ['Active', 'Draft', 'Out of Stock'], default: 'Active' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Product', ProductSchema);
