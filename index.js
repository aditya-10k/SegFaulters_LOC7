require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectToDatabase= require('./config/database.js'); 
const authRoutes = require('./routes/authroutes');
const geoRoutes = require('./routes/geoRoutes')
const cookieParser = require('cookie-parser');
const server = express();
server.use(express.json());
server.use(cookieParser());
server.use(cors());

server.use('/api/auth',authRoutes) ;
<<<<<<< HEAD

=======
server.use('/api/geoR', geoRoutes);
>>>>>>> 1f5ff170823fb250dc6ee72945e59366b0e1729c

const port = process.env.PORT || 5000;
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
  connectToDatabase();
});
