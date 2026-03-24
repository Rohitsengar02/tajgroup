const mongoose = require('mongoose');

const routeSchema = mongoose.Schema(
  {
    name: { type: String, required: true },
    status: { 
      type: String, 
      required: true, 
      enum: ['Active', 'Pending', 'Inactive'],
      default: 'Pending'
    },
    startLocation: { type: String, required: true },
    endLocation: { type: String, required: true },
    stops: { type: Number, required: true, default: 0 },
    distance: { type: String, required: true },
    duration: { type: String, required: true },
    vehicle: { type: String, required: true },
    driver: { type: String, required: true },
    assignedHelper: { type: String },
    expectedRevenue: { type: Number, default: 0 },
    totalOrders: { type: Number, default: 0 },
  },
  {
    timestamps: true,
  }
);

const AppRoute = mongoose.model('AppRoute', routeSchema);

module.exports = AppRoute;
