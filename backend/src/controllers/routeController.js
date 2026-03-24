const AppRoute = require('../models/AppRoute');

// @desc    Get all routes
// @route   GET /api/routes
// @access  Public
const getRoutes = async (req, res) => {
  try {
    const routes = await AppRoute.find({});
    res.json(routes);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// @desc    Get route by ID
// @route   GET /api/routes/:id
// @access  Public
const getRouteById = async (req, res) => {
  try {
    const route = await AppRoute.findById(req.params.id);
    if (route) {
      res.json(route);
    } else {
      res.status(404).json({ message: 'Route not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

// @desc    Create a route
// @route   POST /api/routes
// @access  Public
const createRoute = async (req, res) => {
  try {
    const { 
      name, status, startLocation, endLocation, stops, 
      distance, duration, vehicle, driver, 
      assignedHelper, expectedRevenue, totalOrders 
    } = req.body;

    const route = await AppRoute.create({
      name,
      status, 
      startLocation,
      endLocation,
      stops,
      distance,
      duration,
      vehicle,
      driver,
      assignedHelper,
      expectedRevenue,
      totalOrders
    });

    res.status(201).json(route);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error: error.message });
  }
};

// @desc    Update a route
// @route   PUT /api/routes/:id
// @access  Public
const updateRoute = async (req, res) => {
  try {
    const route = await AppRoute.findById(req.params.id);

    if (route) {
      route.name = req.body.name || route.name;
      route.status = req.body.status || route.status;
      route.startLocation = req.body.startLocation || route.startLocation;
      route.endLocation = req.body.endLocation || route.endLocation;
      route.stops = req.body.stops !== undefined ? req.body.stops : route.stops;
      route.distance = req.body.distance || route.distance;
      route.duration = req.body.duration || route.duration;
      route.vehicle = req.body.vehicle || route.vehicle;
      route.driver = req.body.driver || route.driver;
      route.assignedHelper = req.body.assignedHelper || route.assignedHelper;
      route.expectedRevenue = req.body.expectedRevenue !== undefined ? req.body.expectedRevenue : route.expectedRevenue;
      route.totalOrders = req.body.totalOrders !== undefined ? req.body.totalOrders : route.totalOrders;

      const updatedRoute = await route.save();
      res.json(updatedRoute);
    } else {
      res.status(404).json({ message: 'Route not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

// @desc    Delete a route
// @route   DELETE /api/routes/:id
// @access  Public
const deleteRoute = async (req, res) => {
  try {
    const route = await AppRoute.findById(req.params.id);

    if (route) {
      await AppRoute.deleteOne({ _id: route._id });
      res.json({ message: 'Route removed' });
    } else {
      res.status(404).json({ message: 'Route not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server Error' });
  }
};

module.exports = {
  getRoutes,
  getRouteById,
  createRoute,
  updateRoute,
  deleteRoute
};
