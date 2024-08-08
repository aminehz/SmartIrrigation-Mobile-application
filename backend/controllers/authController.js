const { isJWT } = require("validator");
const User = require("../models/User");
const bcrypt=require("bcrypt");
const jwt=require("jsonwebtoken");
const { addToBlacklist } = require('../middleware/blacklistMiddleware');


module.exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: 'User does not exist!' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid credentials' });
    }

    const payload = { user: { id: user._id } };
    const token = jwt.sign(payload, 'test', { expiresIn: '1h' });

    res.json({ token });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ msg: 'Server Error' });
  }
};

module.exports.logout = async (req, res) => {
  const token = req.header('x-auth-token');
  if (!token) {
    return res.status(400).json({ msg: 'No token, Auth denied' });
  }

  try {
    addToBlacklist(token); 
    res.json({ msg: 'Logged out successfully' });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ msg: 'Server Error' });
  }
};

module.exports.getAllUsers= async (req,res) =>{
  try{
    const users= await User.find().select("-password");
    res.json(users);
  }catch(error){
    console.error(error.message);
    res.status(400).json({msg:'Internal server Error'});
  }
}

module.exports.register=async (req,res)=>{
  const {email,password}=req.body;
  try{
    let user= await User.findOne({email});
    if(user){
      return res.status(400).json({msg:'User already Exists try another mail'});
    }
    user= new User({
      email,password
    });
    await user.save();
    res.status(201).json({msg:'User registred.'});
  }catch(error){
    console.error(error.message);
    res.status(500).send('server error');
  }
}

