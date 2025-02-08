
const express = require('express');
const { registerUser, loginUser,logout } = require('../controllers/authcontroller');

const router = express.Router();



router.get("/default-route",  (req, res) => {
  res.status(200).json({ message: "The default one" });
});


router.post('/register', registerUser);
router.post('/login', loginUser);

router.post('/logout', logout);



module.exports = router;
