const express = require("express");
const router = express.Router();
const collabController = require("../controllers/collabcontroller");

// Send a new collaboration request
router.post("/send", collabController.sendRequest);

// Accept a collaboration request
router.put("/accept", collabController.acceptRequest);

// Reject a collaboration request
router.put("/reject", collabController.rejectRequest);

// Get all pending collaboration requests
router.get("/pending", collabController.getAllPendingRequests);

// Get all requests sent by a specific user
router.get("/sent/:userId", collabController.getRequestsSentByUser);

// Get all requests received by a specific user
router.get("/received/:userId", collabController.getRequestsReceivedByUser);

module.exports = router;
