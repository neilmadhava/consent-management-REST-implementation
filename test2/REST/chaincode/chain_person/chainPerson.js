/*
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
*/

'use strict';
const shim = require('fabric-shim');
const util = require('util');

let Chaincode = class {
  async Init(stub) {
    let ret = stub.getFunctionAndParameters();
    console.info(ret);
    console.info('=========== Instantiated Marbles Chaincode ===========');
    return shim.success();
  }

  async Invoke(stub) {
    console.info('Transaction ID: ' + stub.getTxID());
    console.info(util.format('Args: %j', stub.getArgs()));

    let ret = stub.getFunctionAndParameters();
    console.info(ret);

    let method = this[ret.fcn];
    if (!method) {
      console.log('no function of name:' + ret.fcn + ' found');
      throw new Error('Received unknown function ' + ret.fcn + ' invocation');
    }
    try {
      let payload = await method(stub, ret.params, this);
      return shim.success(payload);
    } catch (err) {
      console.log(err);
      return shim.error(err);
    }
  }

  // ===============================================
  // initPerson - create a new person
  // ===============================================
  async initPerson(stub, args, thisClass) {
    if (args.length != 9) {
      throw new Error('Incorrect number of arguments. Expecting 9');
    }
    // ==== Input sanitation ====
    console.info('--- start init person ---')
    if (args[0].lenth <= 0) {
      throw new Error('1st argument must be a non-empty string');
    }
    if (args[1].lenth <= 0) {
      throw new Error('2nd argument must be a non-empty string');
    }
    if (args[2].lenth <= 0) {
      throw new Error('3rd argument must be a non-empty string');
    }
    if (args[3].lenth <= 0) {
      throw new Error('4th argument must be a non-empty string');
    }
    if (args[4].lenth <= 0) {
      throw new Error('5th argument must be a non-empty string');
    }
    if (args[5].lenth <= 0) {
      throw new Error('6th argument must be a non-empty string');
    }
    if (args[6].lenth <= 0) {
      throw new Error('7th argument must be a non-empty string');
    }
    if (args[7].lenth <= 0) {
      throw new Error('8th argument must be a non-empty string');
    }
    if (args[8].lenth <= 0) {
      throw new Error('9th argument must be a non-empty string');
    }
    if (args[8].toLowerCase() !== "low" && args[8].toLowerCase() !== "high" && args[8].toLowerCase() !== "medium"){
      throw new Error('9th argument must be LOW / MEDIUM / HIGH');
    }

    let userID = args[0];
    let source = args[1];
    let name = args[2];
    let departDate = args[3];
    let phone = args[4];
    let creditCard = args[5];
    let aadhar_id = args[6];
    let email = args[7].toLowerCase();
    let consent_type = args[8].toLowerCase();

    // ==== Check if person already exists ====
    let personState = await stub.getPrivateData("testCollection", userID);
    if (personState.toString()) {
      throw new Error('This person already exists: ' + userID);
    }

    // CREATING DATA DEFINITION FOR PUBLIC AND PRIVATE DATA

    let person = {};
    let personPrivate = {};

    person.userID = userID;
    person.source = source;
    person.departDate = departDate;
    person.consent_type = consent_type;
    person.name = name;
    person.phone = phone;
    person.creditCard = creditCard;
    person.aadhar_id = aadhar_id;
    person.email = email;

    if (consent_type === "low"){      
      personPrivate.userID = userID;
      personPrivate.source = source;
      personPrivate.departDate = departDate;
    }
    if (consent_type === "medium"){
      personPrivate.userID = userID;
      personPrivate.source = source;
      personPrivate.departDate = departDate;
      personPrivate.name = name;
      personPrivate.email = email;

    }
    if (consent_type === "high"){
      // ==== Create person object and marshal to JSON ====
      personPrivate.userID = userID;
      personPrivate.source = source;
      personPrivate.departDate = departDate;
      personPrivate.name = name;
      personPrivate.email = email;
      personPrivate.phone = phone;
      personPrivate.aadhar_id = aadhar_id;

    }


    // === Save person to testCollection ===
    await stub.putPrivateData("testCollection", userID, Buffer.from(JSON.stringify(person)));  
    
    // === Save personPrivate to testCollectionPrivate ===
    await stub.putPrivateData("testCollectionPrivate", userID, Buffer.from(JSON.stringify(personPrivate)));

    console.info('- end init person');
  }

  // ===============================================
  // readPerson - read a person - for ccd
  // ===============================================
  async readPerson(stub, args, thisClass) {
    if (args.length != 1) {
      throw new Error('Incorrect number of arguments. Expecting user_id of the person to query');
    }

    let userID = args[0];
    if (!userID) {
      throw new Error(' user_id must not be empty');
    }
    let personAsbytes = await stub.getPrivateData("testCollectionPrivate",userID); //get the person from chaincode state
    if (!personAsbytes.toString()) {
      let jsonResp = {};
      jsonResp.Error = 'Person does not exist: ' + userID;
      throw new Error(JSON.stringify(jsonResp));
    }
    console.info('=======================================');
    console.log(personAsbytes.toString());
    console.info('=======================================');
    return personAsbytes;
  }

  // ============================================================
  // readPrivatePerson - read a person - for airport & users
  // ============================================================
  async readPrivatePerson(stub, args, thisClass) {
    if (args.length != 1) {
      throw new Error('Incorrect number of arguments. Expecting user_id of the person to query');
    }

    let userID = args[0];
    if (!userID) {
      throw new Error(' user_id must not be empty');
    }
    let privatePersonAsbytes = await stub.getPrivateData("testCollection",userID); //get the person from chaincode state
    if (!privatePersonAsbytes.toString()) {
      let jsonResp = {};
      jsonResp.Error = 'Person does not exist: ' + userID;
      throw new Error(JSON.stringify(jsonResp));
    }
    console.info('=======================================');
    console.log(privatePersonAsbytes.toString());
    console.info('=======================================');
    return privatePersonAsbytes;
  }

  // ===================================================
  // deletePerson - delete a person from all collections
  // ===================================================
  async deletePerson(stub, args, thisClass) {
    if (args.length != 1) {
      throw new Error('Incorrect number of arguments. Expecting userID of the person to delete');
    }
    let userID = args[0];
    if (!userID) {
      throw new Error('userID must not be empty');
    }

    let valAsbytes = await stub.getPrivateData("testCollection", userID); //get the person from chaincode state
    let jsonResp = {};
    if (!valAsbytes) {
      jsonResp.error = 'person does not exist';
      throw new Error(jsonResp);
    }

    //remove the person from testCollection
    await stub.deletePrivateData("testCollection", userID);
  }

  // ===================================================
  // revokeConsent - delete a person from ccd collections
  // ===================================================
  async revokeConsent(stub, args, thisClass) {
    if (args.length != 1) {
      throw new Error('Incorrect number of arguments. Expecting userID of the person to delete');
    }
    let userID = args[0];
    if (!userID) {
      throw new Error('userID must not be empty');
    }

    let valAsbytes = await stub.getPrivateData("testCollectionPrivate", userID); //get the person from chaincode state
    let jsonResp = {};
    if (!valAsbytes) {
      jsonResp.error = 'person does not exist';
      throw new Error(jsonResp);
    }

    //remove the person from testCollection
    await stub.deletePrivateData("testCollectionPrivate", userID);
  }

};

shim.start(new Chaincode());
