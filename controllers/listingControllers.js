const Listing = require("../models/listingSchema");
const UserNgo = require('../models/ngoSchema');  // Assuming the model file is named ngoModel.js

// Create a new listing
exports.createListing = async (req, res) => {
    const { ngo_id, title, description, funding_required, volunteers_available } = req.body;

    try {
        // Validate required fields
        if (!ngo_id || !title || !description || funding_required === undefined || volunteers_available === undefined) {
            return res.status(400).json({ error: "All fields are required" });
        }

        // Validate numerical fields
        if (funding_required < 0 || volunteers_available < 0) {
            return res.status(400).json({ error: "Funding and volunteers must be non-negative numbers" });
        }

        // Create the listing
        const listing = new Listing({
            ngo_id,
            title,
            description,
            funding_required,
            volunteers_available,
        });

        await listing.save();

        res.status(201).json({
            message: "Listing created successfully",
            listing: {
                id: listing._id,
                ngo_id: listing.ngo_id,
                title: listing.title,
                description: listing.description,
                funding_required: listing.funding_required,
                volunteers_available: listing.volunteers_available,
                createdAt: listing.createdAt,
                updatedAt: listing.updatedAt,
            },
        });
    } catch (err) {
        res.status(500).json({ error: "Failed to create listing", details: err.message });
    }
};


exports.updateListing = async (req, res) => {
    const { title, description, funding_required, volunteers_available } = req.body;
    const { id } = req.params;

    try {
        // Find the listing
        const listing = await Listing.findById(id);
        if (!listing) {
            return res.status(404).json({ error: "Listing not found" });
        }

        // Validate if at least one field is being updated
        if (!title && !description && funding_required === undefined && volunteers_available === undefined) {
            return res.status(400).json({ error: "At least one field must be updated" });
        }

        // Validate numerical fields if provided
        if (funding_required !== undefined && funding_required < 0) {
            return res.status(400).json({ error: "Funding must be a non-negative number" });
        }

        if (volunteers_available !== undefined && volunteers_available < 0) {
            return res.status(400).json({ error: "Volunteers must be a non-negative number" });
        }

        // Update the listing fields if they are provided
        if (title) listing.title = title;
        if (description) listing.description = description;
        if (funding_required !== undefined) listing.funding_required = funding_required;
        if (volunteers_available !== undefined) listing.volunteers_available = volunteers_available;

        await listing.save();

        res.status(200).json({
            message: "Listing updated successfully",
            listing: {
                id: listing._id,
                ngo_id: listing.ngo_id,
                title: listing.title,
                description: listing.description,
                funding_required: listing.funding_required,
                volunteers_available: listing.volunteers_available,
                createdAt: listing.createdAt,
                updatedAt: listing.updatedAt,
            },
        });
    } catch (err) {
        res.status(500).json({ error: "Failed to update listing", details: err.message });
    }
};

exports.deleteListing = async (req, res) => {
    const { id } = req.params;

    try {
        // Find the listing
        const listing = await Listing.findById(id);
        if (!listing) {
            return res.status(404).json({ error: "Listing not found" });
        }

        // Delete the listing
        await listing.deleteOne();

        res.status(200).json({
            message: "Listing deleted successfully",
            listing: {
                id: listing._id,
                ngo_id: listing.ngo_id,
                title: listing.title,
                description: listing.description,
                funding_required: listing.funding_required,
                volunteers_available: listing.volunteers_available,
                createdAt: listing.createdAt,
                updatedAt: listing.updatedAt,
            },
        });
    } catch (err) {
        res.status(500).json({ error: "Failed to delete listing", details: err.message });
    }
};

exports.getListingById = async (req, res) => {
    const { id } = req.params;

    try {
        // Find the listing by ID
        const listing = await Listing.findById(id).populate("ngo_id", "name email");
        if (!listing) {
            return res.status(404).json({ error: "Listing not found" });
        }

        res.status(200).json({
            message: "Listing retrieved successfully",
            listing: {
                id: listing._id,
                ngo_id: listing.ngo_id,
                title: listing.title,
                description: listing.description,
                funding_required: listing.funding_required,
                volunteers_available: listing.volunteers_available,
                createdAt: listing.createdAt,
                updatedAt: listing.updatedAt,
            },
        });
    } catch (err) {
        res.status(500).json({ error: "Failed to retrieve listing", details: err.message });
    }
};
