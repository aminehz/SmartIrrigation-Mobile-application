//const express=require('express');
const mongoose=require('mongoose');
const {isEmail} = require('validator');
const bcrypt= require('bcrypt');
/*const session =require('express-session');
const app=express();*/

const userSchema=new mongoose.Schema({
    email:{
        type:String,
        requied:[true,'Please enter an email'],
        unique:true,
        lowercase:true,
        // validate:[,'Please enter a valid email']
    },
    password:{
        type:String,
        required:[true,'Please enter a password'],
        minlength:[6,'Minimum password length is 6 characters']
    },
});

/*app.use(session({
secret:"some secret",
cookie:{maxAge:30000},
saveUninitialized:false
}));*/

userSchema.pre('save',async function(next){
    if(!this.isModified('password')){
        return next();
    }
    const salt=await bcrypt.genSalt(10);
    this.password= await bcrypt.hash(this.password,salt);
    next();
})

userSchema.statics.login = async function(email , password){
    const user = await this.findOne({email:email});
    console.log(user);
    if (user) {
        let auth = false;

        if (auth == false) {
                if(password === user.password){
                    auth= true;
                    return user;
                   
                }
                
        }
        throw Error('incorrect password');
        
      }
    
    throw Error('incorrect email');
};

const User=mongoose.model('user',userSchema);

module.exports=User;