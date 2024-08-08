const { Router } = require('express');
const authController = require('../controllers/authController');
const electrovanneController = require('../controllers/electrovanneController');
const graphicController = require('../controllers/graphicController');
const auth = require('../middleware/auth');
const router = Router();

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/logout', auth, authController.logout);

router.get('/getUsers', auth, authController.getAllUsers);
router.get('/electrovanne', auth, electrovanneController.electrovanneGet);
router.post('/electrovanne', auth, electrovanneController.electrovanneAdd);
router.delete('/electrovanne/:id', auth, electrovanneController.electrovanneDelete);
router.post('/graphic', auth, graphicController.Graphic_post);
router.get('/graphic', auth, graphicController.Graphic_get);

module.exports = router;
