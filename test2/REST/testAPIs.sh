#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi

starttime=$(date +%s)

CC_SRC_PATH="$PWD/chaincode/chain_person"
CC_CCP_PATH="$PWD/chaincode/chain_person/collections_config.json"
LANGUAGE="node"

echo "POST request Enroll on airport  ..."
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Mukunda&orgName=airport')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $ORG1_TOKEN"
echo



echo "POST request Enroll on ccd ..."
echo
ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Madhava&orgName=ccd')
echo $ORG2_TOKEN
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG2 token is $ORG2_TOKEN"
echo



echo "POST request Enroll on users ..."
echo
ORG3_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Barry&orgName=users')
echo $ORG3_TOKEN
ORG3_TOKEN=$(echo $ORG3_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG3 token is $ORG3_TOKEN"
echo



echo "POST request Enroll on mcd ..."
echo
ORG4_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Allen&orgName=mcd')
echo $ORG4_TOKEN
ORG4_TOKEN=$(echo $ORG4_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG4 token is $ORG4_TOKEN"
echo


echo
echo "POST request Create channel  ..."
echo
curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"mychannel",
	"channelConfigPath":"../../channel-artifacts/channel.tx"
}'
echo
echo
sleep 5


echo "POST request Join channel on Airport"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/peers \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.airport.example.com","peer1.airport.example.com"]
}'
echo
echo

echo "POST request Join channel on CCD"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/peers \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.ccd.example.com","peer1.ccd.example.com"]
}'
echo
echo

echo "POST request Join channel on Users"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/peers \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "peers": ["peer0.users.example.com","peer1.users.example.com"]
}'
echo
echo

echo "POST request Join channel on MCD"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/peers \
  -H "authorization: Bearer $ORG4_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "peers": ["peer0.mcd.example.com","peer1.mcd.example.com"]
}'
echo
echo

echo "POST request Update anchor peers on Airport"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/anchorpeers \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"configUpdatePath":"../../channel-artifacts/airportanchors.tx"
}'
echo
echo

echo "POST request Update anchor peers on CCD"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/anchorpeers \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"configUpdatePath":"../../channel-artifacts/ccdanchors.tx"
}'
echo
echo

echo "POST request Update anchor peers on Users"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/anchorpeers \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "configUpdatePath":"../../channel-artifacts/usersanchors.tx"
}'
echo
echo

echo "POST request Update anchor peers on MCD"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/anchorpeers \
  -H "authorization: Bearer $ORG4_TOKEN" \
  -H "content-type: application/json" \
  -d '{
  "configUpdatePath":"../../channel-artifacts/mcdanchors.tx"
}'
echo
echo

echo "POST Install chaincode on Airport"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.airport.example.com\",\"peer1.airport.example.com\"],
	\"chaincodeName\":\"newv3\",
	\"chaincodePath\":\"$CC_SRC_PATH\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"chaincodeVersion\":\"1.0\"
}"
echo
echo

echo "POST Install chaincode on CCD"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.ccd.example.com\",\"peer1.ccd.example.com\"],
  \"chaincodeName\":\"newv3\",
  \"chaincodePath\":\"$CC_SRC_PATH\",
  \"chaincodeType\": \"$LANGUAGE\",
  \"chaincodeVersion\":\"1.0\"
}"
echo
echo

echo "POST Install chaincode on Users"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.users.example.com\",\"peer1.users.example.com\"],
  \"chaincodeName\":\"newv3\",
  \"chaincodePath\":\"$CC_SRC_PATH\",
  \"chaincodeType\": \"$LANGUAGE\",
  \"chaincodeVersion\":\"1.0\"
}"
echo
echo

echo "POST Install chaincode on MCD"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG4_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.mcd.example.com\",\"peer1.mcd.example.com\"],
  \"chaincodeName\":\"newv3\",
  \"chaincodePath\":\"$CC_SRC_PATH\",
  \"chaincodeType\": \"$LANGUAGE\",
  \"chaincodeVersion\":\"1.0\"
}"
echo
echo

echo "POST instantiate chaincode on Airport"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.airport.example.com\"],
	\"chaincodeName\":\"newv3\",
	\"chaincodeVersion\":\"1.0\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"args\":[\"init\"],
  \"collectionsConfig\":\"$CC_CCP_PATH\"
}"
echo
echo


sleep 10

echo "POST invoke INITLEDGER chaincode on peers of Airport, CCD and Users"
echo
VALUES=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/newv3 \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.airport.example.com\"],
  \"fcn\":\"initPerson\",
  \"args\":[\"user_01\",\"Delhi\",\"Mukunda\",\"31-Jan-2020\",\"8178637565\", \"card_01\", \"uid001\", \"mm@gmail.com\", \"medium\"]
}")
echo $VALUES
# Assign previous invoke transaction id  to TRX_ID
MESSAGE=$(echo $VALUES | jq -r ".message")
TRX_ID=${MESSAGE#*ID: }
echo

sleep 10

# ORG1_TOKEN stores token for AIRPORT
echo "Query as Airport"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=readPrivatePerson&args=%5B%22user_01%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

# ORG2_TOKEN stores token for CCD
echo
echo echo "Query as CCD"
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=readPerson&args=%5B%22user_01%22%2C%20%22ccd%22%5D" \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo
echo
echo echo "Query as MCD"
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=readPerson&args=%5B%22user_01%22%2C%20%22mcd%22%5D" \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json"
echo
echo

# ORG3_TOKEN stores token for USERS
sleep 5
echo "POST invoke REVOKE_CONSENT for ccd chaincode on peers of Airport"
echo
VALUES=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/newv3 \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.airport.example.com\"],
  \"fcn\":\"revokeConsent\",
  \"args\":[\"user_01\", \"ccd\"]
}")
echo $VALUES
# Assign previous invoke transaction id  to TRX_ID
MESSAGE=$(echo $VALUES | jq -r ".message")
TRX_ID=${MESSAGE#*ID: }
echo

sleep 10


echo "GET query chaincode on peer0 of CCD"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=readPerson&args=%5B%22user_01%22%2C%20%22ccd%22%5D" \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "POST invoke GIVE_CONSENT for ccd chaincode on peers of Airport"
echo
VALUES=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/newv3 \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.airport.example.com\"],
  \"fcn\":\"giveConsent\",
  \"args\":[\"user_01\", \"low\", \"CCD\"]
}")
echo $VALUES
# Assign previous invoke transaction id  to TRX_ID
MESSAGE=$(echo $VALUES | jq -r ".message")
TRX_ID=${MESSAGE#*ID: }
echo

sleep 10

echo "GET query chaincode on peer0 of CCD"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=readPerson&args=%5B%22user_01%22%2C%20%22ccd%22%5D" \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "Query all users on chaincode on peer0 of Airport"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=getPersonsByRange&args=%5B%22%22%2C%20%22%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "POST invoke DELETE_PERSON chaincode on peers of Airport, CCD and Users"
echo
VALUES=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/newv3 \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.airport.example.com\"],
  \"fcn\":\"deletePerson\",
  \"args\":[\"user_01\"]
}")
echo $VALUES
# Assign previous invoke transaction id  to TRX_ID
MESSAGE=$(echo $VALUES | jq -r ".message")
TRX_ID=${MESSAGE#*ID: }
echo

sleep 10

echo "GET query chaincode on peer0 of Airport"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=readPrivatePerson&args=%5B%22user_01%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "GET history query chaincode on peer0 of Airport"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=getHistoryForPerson&args=%5B%22user_01%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo




# echo "GET query Block by blockNumber"
# echo
# BLOCK_INFO=$(curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/blocks/1?peer=peer0.org1.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json")
# echo $BLOCK_INFO
# # Assign previous block hash to HASH
# HASH=$(echo $BLOCK_INFO | jq -r ".header.previous_hash")
# echo

# echo "GET query Transaction by TransactionID"
# echo
# curl -s -X GET http://localhost:4000/channels/mychannel/transactions/$TRX_ID?peer=peer0.org1.example.com \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo


# echo "GET query Block by Hash - Hash is $HASH"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/blocks?hash=$HASH&peer=peer0.org1.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "cache-control: no-cache" \
#   -H "content-type: application/json" \
#   -H "x-access-token: $ORG1_TOKEN"
# echo
# echo

# echo "GET query ChainInfo"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel?peer=peer0.org1.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

# echo "GET query Installed chaincodes"
# echo
# curl -s -X GET \
#   "http://localhost:4000/chaincodes?peer=peer0.org1.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

# echo "GET query Instantiated chaincodes"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/chaincodes?peer=peer0.org1.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

# echo "GET query Channels"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels?peer=peer0.org1.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
