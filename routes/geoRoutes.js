const express = require("express");
const router = express.Router();
const geoController = require("../controllers/geoController");

// Route to save a location
router.post("/save-location", geoController.saveLocation);

// Route to search nearby locations
router.post("/find-nearby", geoController.findNearby);

module.exports = router;
