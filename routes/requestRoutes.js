const express = require("express");
const router = express.Router();
const collabController = require("../controllers/collabcontroller");


router.post("/send", collabController.sendRequest);


router.put("/accept", collabController.acceptRequest);


router.put("/reject", collabController.rejectRequest);

router.get("/pending", collabController.getAllPendingRequests);

router.get("/sent/:userId", collabController.getRequestsSentByUser);


router.get("/received/:userId", collabController.getRequestsReceivedByUser);

module.exports = router;
