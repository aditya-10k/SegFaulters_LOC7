const express = require("express");
const router = express.Router();
const geoController = require("../controllers/geoController");





router.post("/find-nearbyCorporate", geoController.findNearbyCorporate);
router.post("/find-nearbyNgo", geoController.findNearbyNgo);

module.exports = router;
