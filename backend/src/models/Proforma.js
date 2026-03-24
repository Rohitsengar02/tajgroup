const mongoose = require('mongoose');

const proformaSchema = new mongoose.Schema({
  invoiceId: { type: String, required: true },
  customer: { type: String, required: true },
  date: { type: String, required: true }, // Create date
  due: { type: String, required: true }, // Due date
  amount: { type: String, required: true },
  status: { type: String, default: "Pending" } 
}, { timestamps: true });

module.exports = mongoose.model('Proforma', proformaSchema);
