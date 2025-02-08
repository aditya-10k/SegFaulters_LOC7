const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const CorporateSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Full name is required'],
      trim: true,
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      match: [/.+@.+\..+/, 'Please provide a valid email address'],
    },
    password: {
      type: String,
      minlength: [6, 'Password must be at least 6 characters long'],
      required: true,
    },
    phone: {
      type: String,
      required: [true, 'Phone number is required'],
      match: [/^\d{10,15}$/, 'Please provide a valid phone number'],
    },
    address: {
      type: String,
      required: [true, 'Address is required'],
      trim: true,
    },
    sectors: {
      type: [String],
      required: [true, 'At least one sector is required'],
    },
    description: {
      type: String,
      maxlength: [500, 'Description cannot exceed 500 characters'],
      trim: true,
    },
    csr_budget: {
      type: Number,
      required: [true, 'CSR Budget is required'],
      min: [0, 'CSR Budget cannot be negative'],
    },
    location: {
      type: {
        type: String,
        enum: ["Point"],
        
      },
      coordinates: {
        type: [Number], // Longitude, Latitude
        required: true,
        validate: {
          validator: function (val) {
            return val.length === 2;
          },
          message: "Coordinates must contain only two points [longitude, latitude]",
        },
      },
    },
  },
  {
    timestamps: true, 
  }
);

CorporateSchema.index({ location: "2dsphere" });


CorporateSchema.pre("save", async function (next) {
  if (this.isModified("password")) {
    try {
      const salt = await bcrypt.genSalt(10);
      this.password = await bcrypt.hash(this.password, salt);
    } catch (error) {
      return next(error);
    }
  }
  next();
});

module.exports = mongoose.model("UserCorporate", CorporateSchema);
