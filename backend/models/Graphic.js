const mongoose=require('mongoose');

const graphicSchema=new mongoose.Schema({
x:{
    type:String,
    required:true
},
y:{ 
    type:Number,
    required:true
}
});

const Graphic=mongoose.model('graphic',graphicSchema);

module.exports=Graphic;