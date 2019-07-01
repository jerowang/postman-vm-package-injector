const env = require('./environment.orig');
var fs = require('fs');
var path = require('path')

var file = fs.readFileSync(path.join(__dirname, '../../packages.config'), 'utf8');

pkgs = file.split(',');
pkgs.forEach(pkg => {
  env.require[pkg] = { glob: true };
});

var defaultModules = ["crypto"]
defaultModules.forEach(pkg => {
  env.require[pkg] = { preferBuiltin: true, glob: true };
});

// env.require.net = { resolve: '../vendor/net', expose: 'net', glob: true };
env.files['../vendor/net'] = true;

module.exports = env;
