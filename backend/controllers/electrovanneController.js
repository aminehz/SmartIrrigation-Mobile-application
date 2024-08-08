const Electrovanne = require("../models/Electrovanne");

module.exports.electrovanneGet = async (req, res) => {
  try {
    const electrovanne = await Electrovanne.find({ user: req.user.id });
    res.json(electrovanne);
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ msg: "Server Error" });
  }
};

module.exports.electrovanneAdd = async (req, res) => {
  const { nom, status } = req.body;
  try {
    const newElectrovanne = new Electrovanne({
      nom,
      status,
      user: req.user.id
    });

    await newElectrovanne.save();
    res.status(201).json(newElectrovanne);
  } catch (err) {
    console.log('Error adding electrovanne',err);
    res.status(400).json({ msg: 'Error adding electrovanne' });
  }
};

module.exports.electrovanneDelete = async (req, res) => {
  const electrovanneId = req.params.idElectrovanne;
  try {
    const electrovanne = await Electrovanne.findById(electrovanneId);
    if (!electrovanne) {
      return res.status(404).json({ msg: "Electrovanne dosent exist" });
    }
    if (electrovanne.user.toString() !== req.user.id) {
      return res.status(401).json({ msg: "Not authorized" });
    }

    await electrovanne.remove();
    res.json({ msg: "Electrovanne removed" });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ msg: "Server Error" });
  }
};
