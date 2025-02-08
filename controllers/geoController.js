const Location = require("../models/Location");

exports.saveLocation = async (req, res) => {
    try {
        const { longitude, latitude } = req.body;
        if (!latitude || !longitude) {
            return res.status(400).json({ error: "Both latitude and longitude are compulsory" });
        }

        const newLocation = new Location({
            location: {
                type: "Point",
                coordinates: [longitude, latitude]
            }
        });
        await newLocation.save();
        res.status(201).json({ message: "Location saved...", data: newLocation });
    } catch (error) {
        res.status(500).json({ error: "Internal server error" })
    }
};

exports.findNearby = async (req, res) => {
    try {
        const { latitude, longitude, max } = req.body;

        if (!latitude || !longitude || !max) {
            return res.status(400).json({ error: "Latitude, Longitude, and maxDistance are required" });
        }

        const locations = await Location.find({
            location: {
                $nearSphere: {
                    $geometry: {
                        type: "Point",
                        coordinates: [longitude, latitude] // GeoJSON requires [longitude, latitude]
                    },
                    $maxDistance: max,
                    $minDistance: 10// Distance in meters
                }
            }
        });

        res.status(200).json({ message: "Nearby locations found", data: locations });

    } catch (error) {
        res.status(501).json({ error: "Internal Server Error", details: error.message });
    }
};

// module.exports={findNearby}