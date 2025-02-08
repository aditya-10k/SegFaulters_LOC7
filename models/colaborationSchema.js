const mongoose = require('mongoose');

const CollaborationSchema = new mongoose.Schema(
  {
    corporate_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'UserCorporate',
      required: true,
    },
    ngo_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'UserNgo',
      required: true,
    },
    status: {
      type: [String], 
      required: true,
      default: ['Active'], 
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
  {
    timestamps: true, 
  }
);

module.exports = mongoose.model('Collaboration', CollaborationSchema);
