const mongoose = require('mongoose');

const challanSchema = new mongoose.Schema({
  challanId: { type: String, required: true },
  customer: { type: String, required: true },
  date: { type: String, required: true },
  driver: { type: String, required: true },
  items: { type: String, required: true },
  routeInfo: { type: String, default: "Warehouse A -> Main Store" },
  status: { type: String, default: "In Transit" }
}, { timestamps: true });

module.exports = mongoose.model('Challan', challanSchema);
