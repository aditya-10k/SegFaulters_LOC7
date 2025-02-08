
const User = require('../models/userSchema');
const { generateToken } = require('../config/utils');
const bcrypt = require('bcryptjs');

exports.registerUser = async (req, res) => {
    const { name, email, password ,address} = req.body;
  
    try {
      if (!name || !email || !password || !address) {
        return res.status(400).json({ message: "All fields are required" });
      }
      if (password.length < 6) {
        return res.status(400).json({ message: "Password must be at least 6 characters" });
      }
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ error: 'Email already registered' });
      }
  

  
      const user = new User({ name, email, password ,address });
  
  
      await user.save();
  
   
      const token = generateToken(user._id, res);
  
      res.status(201).json({
        message: 'User registered successfully',
        token,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          address: user.address,
        },
      });
    } catch (err) {
      res.status(400).json({ error: 'Registration failed', details: err.message });
    }
  };

  exports.loginUser = async (req, res) => {
    const { email, password } = req.body;
  
    try {
      const user = await User.findOne({ email });
  
      if (!user) {
        return res.status(400).json({ error: 'Invalid credentials' });
      }
  
      const isMatch = await bcrypt.compare(password, user.password);
  
      if (!isMatch) {
        return res.status(400).json({ error: 'Invalid credentials' });
      }
  
      const token = generateToken(user._id, res);
  
      res.status(200).json({
        token,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          address: user.address
        },
      });
    } catch (err) {
      res.status(400).json({ error: 'Login failed', details: err.message });
    }
  };




  exports.logout = (req, res) => {
    try {
      res.cookie("jwt", "", { maxAge: 0 });
      res.status(200).json({ message: "Logged out successfully" });
    } catch (error) {
      console.log("Error in logout controller", error.message);
      res.status(500).json({ message: "Internal Server Error" });
    }
  };