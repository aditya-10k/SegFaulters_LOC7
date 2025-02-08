require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectToDatabase = require('./config/database.js');
const authRoutes = require('./routes/authroutes');
const geoRoutes = require('./routes/geoRoutes')
const dataRoutes = require('./routes/dataRoutes')
const requestRoutes = require('./routes/requestroutes');
const cookieParser = require('cookie-parser');

//Collab Routes
const collabRoutes = require("./routes/collabRoutes");

//All Listings here
const listings = require("./routes/listingRoutes");

const server = express();
server.use(express.json());
server.use(cookieParser());
server.use(cors());

//Listings
server.use('/api/listing', listings);

//Collab routes
server.use("/api/collaborations", collabRoutes);

server.use('/api/auth', authRoutes);
server.use('/api/geoR', geoRoutes);
server.use('/api/data', dataRoutes);
server.use('/api/data', requestRoutes);

const port = process.env.PORT || 5000;
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
  connectToDatabase();
});
