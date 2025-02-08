const mongoose = require("mongoose");

const CollaborationSchema = new mongoose.Schema(
  {
    corporate_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Corporate",
      required: true,
    },
    ngo_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "NGO",
      required: true,
    },
    status: {
      type: String,
      enum: ["Active", "Completed", "Cancelled"],
      default: "Active",
    },
    funds_allocated: {
      type: Number,
      required: true,
      min: 0,
    },
    volunteers_involved: {
      type: Number,
      required: true,
      min: 0,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Collaboration", CollaborationSchema);
