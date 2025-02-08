
const express = require('express');
const { getCorporateData,getNgoData } = require('../controllers/getData');

const router = express.Router();



router.get("/default-route",  (req, res) => {
  res.status(200).json({ message: "The default one" });
});


router.get('/getCorporate/:id', getCorporateData);
router.get('/getNgo/:id', getNgoData);




module.exports = router;
