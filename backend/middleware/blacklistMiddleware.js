const jwt = require('jsonwebtoken');

const blacklist = new Set();

function addToBlacklist(token) {
  blacklist.add(token);
}

function isBlacklisted(token) {
  return blacklist.has(token);
}


module.exports = function (req, res, next) {
  const token = req.header('x-auth-token');
  if (!token) {
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  if (isBlacklisted(token)) {
    return res.status(401).json({ msg: 'Token is blacklisted, authorization denied' });
  }

  try {
    const decoded = jwt.verify(token, 'test'); 
    req.user = decoded.user;
    next();
  } catch (err) {
    res.status(401).json({ msg: 'Token is not valid' });
  }
};


module.exports.addToBlacklist = addToBlacklist;
module.exports.isBlacklisted = isBlacklisted;
