const mongoose = require('mongoose');

const DistributionSchema = new mongoose.Schema({
  driverName: { type: String, required: true },
  vehicleNumber: { type: String, required: true },
  route: { type: String, required: true },
  status: { 
    type: String, 
    enum: ['In Transit', 'Completed', 'Pending'], 
    default: 'Pending' 
  },
  totalOrders: { type: Number, default: 0 },
  completedOrders: { type: Number, default: 0 },
  eta: { type: String },
  progress: { type: Number, default: 0 }, // 0.0 to 1.0
  initials: { type: String },
  lastLocation: {
    lat: { type: Number },
    lng: { type: Number },
    timestamp: { type: Date, default: Date.now }
  }
}, { timestamps: true });

module.exports = mongoose.model('Distribution', DistributionSchema);
