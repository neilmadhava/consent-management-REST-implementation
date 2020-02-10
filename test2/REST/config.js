var util = require('util');
var path = require('path');
var hfc = require('fabric-client');

var file = 'network-config.yaml';

// indicate to the application where the setup file is located so it able
// to have the hfc load it to initalize the fabric client instance
hfc.setConfigSetting('network-connection-profile-path',path.join(__dirname, file));
hfc.setConfigSetting('airport-connection-profile-path',path.join(__dirname, 'airport.yaml'));
hfc.setConfigSetting('ccd-connection-profile-path',path.join(__dirname, 'ccd.yaml'));
hfc.setConfigSetting('users-connection-profile-path',path.join(__dirname, 'users.yaml'));
// some other settings the application might need to know
hfc.addConfigFile(path.join(__dirname, 'config.json'));
