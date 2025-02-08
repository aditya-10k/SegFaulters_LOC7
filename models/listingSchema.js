const mongoose = require("mongoose");

const Listings = new mongoose.Schema(
  {
    ngo_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "userngos", 
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    funding_required: {
      type: Number,
      required: true,
      min: 0,
    },
    volunteers_available: {
      type: Number,
      required: true,
      min: 0,
    },
  
  },
  { timestamps: true } 
);

module.exports = mongoose.model("Listings", Listings);
