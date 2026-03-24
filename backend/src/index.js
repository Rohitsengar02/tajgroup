const dns = require('dns');
dns.setServers(['8.8.8.8', '8.8.4.4']);
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const productRoutes = require('./routes/productRoutes');
const orderRoutes = require('./routes/orderRoutes');
const quotationRoutes = require('./routes/quotationRoutes');
const uploadRoutes = require('./routes/uploadRoutes');
const teamMemberRoutes = require('./routes/teamMemberRoutes');
const customerRoutes = require('./routes/customerRoutes');
const appRoutes = require('./routes/appRoutes');
const attendanceRoutes = require('./routes/attendanceRoutes');
const schemeRoutes = require('./routes/schemeRoutes');
const proformaRoutes = require('./routes/proformaRoutes');
const challanRoutes = require('./routes/challanRoutes');

dotenv.config();

connectDB();

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('TajPro ERP API is running...');
});

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/quotations', quotationRoutes);
app.use('/api/uploads', uploadRoutes);
app.use('/api/team', teamMemberRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/routes', appRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/schemes', schemeRoutes);
app.use('/api/proformas', proformaRoutes);
app.use('/api/challans', challanRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
