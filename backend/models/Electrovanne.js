const mongoose=require('mongoose');

const electrovanneSchema=new mongoose.Schema({
    nom:{
        type:String,
        required:true
    },
    status:{
        type:Boolean,
        required:true
    },
    user: {
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true
    }
});

const Electrovanne=mongoose.model('electrovanne',electrovanneSchema);

module.exports=Electrovanne;