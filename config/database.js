const mongoose = require('mongoose');
require('dotenv').config();

const url = process.env.CONNECT_STRING;

if (!url) {
  console.error('Error connecting to MongoDB: no connection string provided');
  process.exit(1);
}

const connectToDatabase = async () => {
  try {
    await mongoose.connect(url);
    console.log('Connected to MongoDB');
  } catch (error) {
    console.error('Error connecting to MongoDB:', error.message);
    process.exit(1);
  }
};


module.exports = connectToDatabase;
