const dns = require('dns');
dns.setServers(['8.8.8.8', '8.8.4.4']);
const mongoose = require('mongoose');
const { Admin, SuperStockist, Distributor, SalesPerson, Retailer } = require('./models/User');
const Order = require('./models/Order');
const connectDB = require('./config/db');
const dotenv = require('dotenv');

dotenv.config();

const users = [
  {
    fullName: 'System Administrator',
    email: 'admin@tajpro.com',
    password: 'password123',
    role: 'Admin',
  },
  {
    fullName: 'Main Super Stockist',
    email: 'stockist@tajpro.com',
    password: 'password123',
    role: 'Super Stockist',
  },
  {
    fullName: 'Regional Distributor',
    email: 'distributor@tajpro.com',
    password: 'password123',
    role: 'Distributor',
  },
  {
    fullName: 'Field Sales Executive',
    email: 'sales@tajpro.com',
    password: 'password123',
    role: 'Sales Person',
  },
  {
    fullName: 'Retail Partner',
    email: 'retailer@tajpro.com',
    password: 'password123',
    role: 'Retailer',
  },
];

const orders = [
  {
    orderId: 'ORD-1001',
    customerName: 'Retail Mart Delhi',
    items: [
      { productName: 'Rice 5kg', quantity: 10, price: 450, image: 'https://res.cloudinary.com/dkahbm2m4/image/upload/v1/samples/food/pot-mussels.jpg' },
      { productName: 'Wheat Flour 10kg', quantity: 5, price: 380, image: 'https://res.cloudinary.com/dkahbm2m4/image/upload/v1/samples/food/spices.jpg' },
    ],
    totalAmount: 6400,
    createdBy: 'admin@tajpro.com',
  },
  {
    orderId: 'ORD-1002',
    customerName: 'Fresh Organics Mumbai',
    items: [
      { productName: 'Sugar 1kg', quantity: 50, price: 42, image: 'https://res.cloudinary.com/dkahbm2m4/image/upload/v1/samples/food/dessert.jpg' },
    ],
    totalAmount: 2100,
    createdBy: 'stockist@tajpro.com',
  },
];

const seedData = async () => {
  try {
    await connectDB();

    // Clear existing data in all collections
    await Admin.deleteMany();
    await SuperStockist.deleteMany();
    await Distributor.deleteMany();
    await SalesPerson.deleteMany();
    await Retailer.deleteMany();
    await Order.deleteMany();
    console.log('Cleared existing collections');

    // Seed Admin
    const adminUser = await Admin.create(users[0]);
    // Seed Super Stockist
    const stockistUser = await SuperStockist.create(users[1]);
    // Seed Distributor
    const distributorUser = await Distributor.create(users[2]);
    // Seed Sales Person
    const salesUser = await SalesPerson.create(users[3]);
    // Seed Retailer
    const retailerUser = await Retailer.create(users[4]);

    // Seed Orders
    await Order.insertMany(orders);

    console.log('Seeded Collections Successfully: admins, super_stockists, distributors, sales_persons, retailers, orders');

    console.log('\n--- Credentials for Realtime Login ---');
    console.log(`Admin (admins): ${adminUser.email} / password123`);
    console.log(`Super Stockist (super_stockists): ${stockistUser.email} / password123`);
    console.log(`Distributor (distributors): ${distributorUser.email} / password123`);
    console.log(`Sales Person (sales_persons): ${salesUser.email} / password123`);
    console.log(`Retailer (retailers): ${retailerUser.email} / password123`);

    process.exit();
  } catch (error) {
    console.error('Error seeding data:', error);
    process.exit(1);
  }
};

seedData();
