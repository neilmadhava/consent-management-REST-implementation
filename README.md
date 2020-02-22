# Consent Management using Blockchain (Hyperledger Fabric)

## Description
Data is the new oil. Whoever has data has power. Cambridge Analytica was in the news recently for having misused user data (data which was acquired without user consent) to influence the results of 2016 US elections and Brexit. When David Carroll sued the company to release his data to him, the company pleaded guilty for not giving his data. Companies like Google, Facebook and Amazon store huge amounts of data about their users over which there is little control. 

This project aims to give back the control over data, to the user. The project assumes 3 organizations - Airport, CCD (Cafe Coffee Day), Users. The members of Users organization share personal information (phone, email, credit card info among others) with Airport organization which must be kept confidential. CCD represents any 3rd party organization with which data is shared on a consent basis. The user can choose to share complete or partial data with CCD and can also revoke consent at any time. In this way, users are in complete control over their data.

## Run the network

```bash
cd test2/REST/
./runApp.sh
./testAPIs.sh
```

./runApp.sh starts the server with which client applications interact with to perform various operations such as registering users, creating channel and so on.

./testAPIs.sh runs through all the interactions with the server.

## Description of APIs

Route | Method| Description
-------|-------|-----------|
/users | POST | Register and enroll user|
/channels | POST | Create Channel
/channels/:channelName/peers | POST | Join Channel
/channels/:channelName/anchorpeers | POST | Update Anchor Peers
/chaincodes | POST | Install chaincode on target peers
/channels/:channelName/chaincodes | POST | Instantiate chaincode on target peers
/channels/:channelName/chaincodes/:chaincodeName | POST | Invoke transaction on chaincode on target peers
/channels/:channelName/chaincodes/:chaincodeName | GET | Query on chaincode on target peers

## Frontend Implementation

https://github.com/neilmadhava/frontend-consent