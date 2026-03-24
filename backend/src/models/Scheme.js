const mongoose = require('mongoose');

const schemeSchema = new mongoose.Schema({
  title: { type: String, required: true },
  type: { type: String, required: true, enum: ["Percentage", "Value", "Quantity", "Combo", "Flat"] }, 
  status: { type: String, default: "Active", enum: ["Active", "Upcoming", "Expired"] },
  products: { type: String, required: true }, 
  discountValue: { type: String, required: true },
  startDate: { type: String, required: true }, 
  endDate: { type: String, required: true }, 
  usage: { type: String, default: "0%" },
  progress: { type: Number, default: 0.0 },
  imageUrl: { type: String, default: "" }, 
}, { timestamps: true });

module.exports = mongoose.model('Scheme', schemeSchema);
