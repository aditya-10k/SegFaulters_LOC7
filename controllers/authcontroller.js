const UserCorporate = require('../models/corporateSchema');
const UserNgo= require('../models/ngoSchema');
const { generateToken } = require('../config/utils');
const bcrypt = require('bcryptjs');

exports.registerUserNgo = async (req, res) => {
    const { name, email, password, address, phone, sectors, description, longitude, latitude } = req.body;

    try {
    
        if (!name || !email || !password || !address || !phone || !sectors) {
            return res.status(400).json({ error: "All fields are required" });
        }

        if (password.length < 6) {
            return res.status(400).json({ error: "Password must be at least 6 characters" });
        }

        if (!latitude || !longitude) {
            return res.status(400).json({ error: "Both latitude and longitude are compulsory" });
        }

        
        const existingUser = await UserNgo.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ error: 'Email already registered' });
        }

        const user = new UserNgo({
            name,
            email,
            password,
            address,
            phone,
            sectors,
            description,
            location: {
                type: "Point",
                coordinates: [longitude, latitude],
            },
        });

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
                phone: user.phone,
                sectors: user.sectors,
                description: user.description,
                location: user.location,
            },
        });
    } catch (err) {
        res.status(500).json({ error: 'Registration failed', details: err.message });
    }
};


exports.registerUserCorporate = async (req, res) => {
    const { name, email, password, address, phone, sectors, description, csr_budget, longitude, latitude } = req.body;

    try {
        // Validate required fields
        if (!name || !email || !password || !address || !phone || !sectors || csr_budget === undefined) {
            return res.status(400).json({ error: "All fields are required" });
        }

        if (password.length < 6) {
            return res.status(400).json({ error: "Password must be at least 6 characters" });
        }

        if (isNaN(csr_budget) || csr_budget < 0) {
            return res.status(400).json({ error: "CSR Budget must be a non-negative number" });
        }

        if (!latitude || !longitude) {
            return res.status(400).json({ error: "Both latitude and longitude are compulsory" });
        }

        // Check if email already exists
        const existingUser = await UserCorporate.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ error: "Email already registered" });
        }

        // Create new corporate user with location
        const user = new UserCorporate({
            name,
            email,
            password,
            address,
            phone,
            sectors,
            description,
            csr_budget,
            location: {
                type: "Point",
                coordinates: [longitude, latitude],
            },
        });

        await user.save();

        
        const token = generateToken(user._id, res);

        res.status(201).json({
            message: "User registered successfully",
            token,
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                address: user.address,
                phone: user.phone,
                sectors: user.sectors,
                description: user.description,
                csr_budget: user.csr_budget,
                location: user.location,
            },
        });
    } catch (err) {
        res.status(500).json({ error: "Registration failed", details: err.message });
    }
};


exports.loginCorporate = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await UserCorporate.findOne({ email });

        if (!user) {
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const token = generateToken(user._id, res);

        res.status(200).json({
            message: 'Login successful',
            token,
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                address: user.address,
                phone: user.phone,
                sectors: user.sectors,
                description: user.description,
            },
        });
    } catch (err) {
        res.status(500).json({ error: 'Login failed', details: err.message });
    }
};

exports.loginNgo = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await UserNgo.findOne({ email });

        if (!user) {
            return res.status(400).json({ error: 'Invalid email or password' });
        } 

        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const token = generateToken(user._id, res);

        res.status(200).json({
            message: 'Login successful',
            token,
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                address: user.address,
                phone: user.phone,
                sectors: user.sectors,
                description: user.description,
            },
        });
    } catch (err) {
        res.status(500).json({ error: 'Login failed', details: err.message });
    }
};

exports.logout = (req, res) => {
    try {
        res.cookie("jwt", "", { maxAge: 0 });
        res.status(200).json({ message: "Logged out successfully" });
    } catch (error) {
        console.error("Error in logout controller:", error.message);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
