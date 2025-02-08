const express = require("express");
const router = express.Router();
const requestController = require("../controllers/collabcontroller");

router.post("/send", requestController.sendRequest);
router.put("/accept", requestController.acceptRequest);
router.put("/reject", requestController.rejectRequest);

module.exports = router;
