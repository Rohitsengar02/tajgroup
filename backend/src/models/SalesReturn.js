const mongoose = require('mongoose');

const SalesReturnSchema = new mongoose.Schema({
  returnId: { type: String, required: true, unique: true },
  customerName: { type: String, required: true },
  items: { type: String, required: true },
  reason: { 
    type: String, 
    enum: ['Expired', 'Damaged', 'Wrong Item', 'Quality Issue', 'Other'], 
    required: true 
  },
  status: { 
    type: String, 
    enum: ['Pending', 'Approved', 'Rejected', 'Replaced', 'Refunded'], 
    default: 'Pending' 
  },
  returnDate: { type: Date, default: Date.now },
  notes: { type: String }
}, { timestamps: true });

module.exports = mongoose.model('SalesReturn', SalesReturnSchema);
