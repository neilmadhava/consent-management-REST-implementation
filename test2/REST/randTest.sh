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
echo

token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODM4NTc3OTYsInVzZXJuYW1lIjoiQmFycnkiLCJvcmdOYW1lIjoidXNlcnMiLCJpYXQiOjE1ODM4MjE3OTZ9.vDQbBwYEq2OWK25uFfdU-z0w3SFlsOfZTOoRzHmr5dQ"

VALUES=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/newv3 \
  -H "authorization: Bearer $token" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.airport.example.com\"],
  \"fcn\":\"initPerson\",
  \"args\":[\"user_02\",\"Bangalore\",\"Madhava\",\"31-Jan-2020\",\"8178637565\", \"card_01\", \"uid001\", \"mm@gmail.com\", \"medium\"]
}")
echo $VALUES
# Assign previous invoke transaction id  to TRX_ID
MESSAGE=$(echo $VALUES | jq -r ".message")
TRX_ID=${MESSAGE#*ID: }
echo

sleep 10

echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=getPersonsByRange&args=%5B%22%22%2C%20%22%22%5D" \
  -H "authorization: Bearer $token" \
  -H "content-type: application/json"
echo
echo


# echo "GET history query chaincode on peer0 of Airport"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/chaincodes/newv3?peer=peer0.airport.example.com&fcn=getHistoryForPerson&args=%5B%22user_01%22%5D" \
#   -H "authorization: Bearer $token" \
#   -H "content-type: application/json" | jq
# echo
# echo

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
