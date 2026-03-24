const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const teamMemberSchema = mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    phone: { type: String },
    role: { 
      type: String, 
      required: true,
      enum: [
        "Admin",
        "Super Stockist",
        "Distributor",
        "Sales Person",
        "Retailer"
      ],
      default: "Sales Person"
    },
    territory: { type: String },
    reportsTo: { type: String },
    monthlyTarget: { type: Number, default: 0 },
    achieved: { type: Number, default: 0 },
    commission: { type: Number, default: 0 },
    joiningDate: { type: Date, default: Date.now },
    isActive: { type: Boolean, default: true },
    address: { type: String },
    profileImage: { type: String },
  },
  {
    timestamps: true,
  }
);

teamMemberSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

teamMemberSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

const TeamMember = mongoose.model('TeamMember', teamMemberSchema);

module.exports = TeamMember;
