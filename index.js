require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectToDatabase= require('./config/database.js'); 
const authRoutes = require('./routes/authroutes');
const cookieParser = require('cookie-parser');
const server = express();
server.use(express.json());
server.use(cookieParser());
server.use(cors());

server.use('/api/auth',authRoutes) ;



const port = process.env.PORT || 5000;
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
  connectToDatabase();
});
