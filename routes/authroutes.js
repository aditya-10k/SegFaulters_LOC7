
const express = require('express');
const { registerUserCorporate, registerUserNgo, loginNgo,loginCorporate,logout } = require('../controllers/authcontroller');

const router = express.Router();



router.get("/default-route",  (req, res) => {
  res.status(200).json({ message: "The default one" });
});


router.post('/registerCorporate', registerUserCorporate);
router.post('/registerNgo', registerUserNgo);
router.post('/loginNgo', loginNgo);
router.post('/loginCorporate', loginCorporate);
router.post('/logout', logout);



module.exports = router;
