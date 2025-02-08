const corporateSchema = require("../models/corporateSchema");
const ngoSchema = require("../models/ngoSchema");

exports.findNearbyCorporate = async (req, res) => {
    try {
        const { latitude, longitude, max } = req.body;

        if (!latitude || !longitude || !max) {
            return res.status(400).json({ error: "Latitude, Longitude, and maxDistance are required" });
        }

        const locations = await corporateSchema.find({
            location: {
                $nearSphere: {
                    $geometry: {
                        type: "Point",
                        coordinates: [longitude, latitude]
                    },
                    $maxDistance: max,
                    $minDistance: 10
                }
            }
        }).select("-password"); // Exclude password field

        res.status(200).json({ message: "Nearby corporates found", data: locations });

    } catch (error) {
        res.status(500).json({ error: "Internal Server Error", details: error.message });
    }
};

exports.findNearbyNgo = async (req, res) => {
    try {
        const { latitude, longitude, max } = req.body;

        if (!latitude || !longitude || !max) {
            return res.status(400).json({ error: "Latitude, Longitude, and maxDistance are required" });
        }

        const locations = await ngoSchema.find({
            location: {
                $nearSphere: {
                    $geometry: {
                        type: "Point",
                        coordinates: [longitude, latitude]
                    },
                    $maxDistance: max,
                    $minDistance: 10
                }
            }
        }).select("-password"); 

        res.status(200).json({ message: "Nearby NGOs found", data: locations });

    } catch (error) {
        res.status(500).json({ error: "Internal Server Error", details: error.message });
    }
};
