const UserCorporate = require("../models/corporateSchema");
const UserNgo = require("../models/ngoSchema");


exports.getCorporateData = async (req, res) => {
    try {
        const { id } = req.params; 

        if (!id) {
            return res.status(400).json({ error: "Corporate ID is required" });
        }

        const user = await UserCorporate.findById(id).select("-password");

        if (!user) {
            return res.status(404).json({ error: "Corporate not found" });
        }

        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error", details: error.message });
    }
};

exports.getNgoData = async (req, res) => {
    try {
        const { id } = req.params;

        if (!id) {
            return res.status(400).json({ error: "NGO ID is required" });
        }

        const user = await UserNgo.findById(id).select("-password");

        if (!user) {
            return res.status(404).json({ error: "NGO not found" });
        }

        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error", details: error.message });
    }
};