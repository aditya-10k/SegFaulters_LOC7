const express = require("express");
const router = express.Router();
const listingsController = require("../controllers/listingsController");

// Create a listing (POST)
router.post("/create", listingsController.createListing);

// Get a listing by ID (GET)
router.get("/getList/:id", listingsController.getListingById);

// Update a listing by ID (PUT)
router.put("/updatList/:id", listingsController.updateListing);

// Delete a listing by ID (DELETE)
router.delete("/deleteList/:id", listingsController.deleteListing);

module.exports = router;
