#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# jq --version > /dev/null 2>&1
# if [ $? -ne 0 ]; then
# 	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
# 	echo
# 	exit 1
# fi

starttime=$(date +%s)

# CC_SRC_PATH="$PWD/chaincode/chain_person01"
# CC_CCP_PATH="$PWD/chaincode/chain_person01/collections_config.json"
# LANGUAGE="node"


ORG1_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODM0NjY4MDcsInVzZXJuYW1lIjoiTXVrdW5kYSIsIm9yZ05hbWUiOiJhaXJwb3J0IiwiaWF0IjoxNTgzNDMwODA3fQ.rR8WTrOUz9cngxtPw9H2vMBffr-hj0rN4R4VKdm3tiI
ORG2_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODM0NjY4MDksInVzZXJuYW1lIjoiTWFkaGF2YSIsIm9yZ05hbWUiOiJjY2QiLCJpYXQiOjE1ODM0MzA4MDl9.nv1gxfxLjZKgo1dFGid8UfXA3-xMWpsLIEi-4G4vFEU
ORG3_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODM0NzMwODMsInVzZXJuYW1lIjoiYmFzaWwiLCJvcmdOYW1lIjoidXNlcnMiLCJpYXQiOjE1ODM0MzcwODN9.qBJXPjghkSNFMgYL6mq3bsp3QswpbpJaesyUXLu-RH4

# echo "GET query chaincode on peer0 of CCD"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/chaincodes/testv10?peer=peer0.ccd.example.com&fcn=readPerson&args=%5B%22user_01%22%5D" \
#   -H "authorization: Bearer $ORG2_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

# echo "GET query GET_HISTORY on peer0 of Airport"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/chaincodes/testv10?peer=peer0.airport.example.com&fcn=getHistoryForPerson&args=%5B%22user_01%22%5D" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

echo "GET query GET_HISTORY on peer0 of Users"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/testv10?peer=peer0.airport.example.com&fcn=readPrivatePerson&args=%5B%22user01%22%5D" \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json"
echo
echo

# echo "GET query Block by blockNumber"
# echo
# BLOCK_INFO=$(curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/blocks/2?peer=peer0.ccd.example.com" \
#   -H "authorization: Bearer $ORG3_TOKEN" \
#   -H "content-type: application/json")
# echo $BLOCK_INFO | jq
# # Assign previous block hash to HASH
# HASH=$(echo $BLOCK_INFO | jq -r ".header.previous_hash")
# echo

# TRX_ID=c10e334e68406ce1bfa205ab63c830986ddd7c615b466cadf1e35ed2b4db7765
# echo "GET query Transaction by TransactionID"
# echo
# curl -s -X GET http://localhost:4000/channels/mychannel/transactions/$TRX_ID?peer=peer0.airport.example.com \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json" | jq -c
# echo
# echo


# echo "GET query Block by Hash - Hash is $HASH"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/blocks?hash=$HASH&peer=peer0.airport.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "cache-control: no-cache" \
#   -H "content-type: application/json" \
#   -H "x-access-token: $ORG1_TOKEN" | jq
# echo
# echo

# echo "GET query ChainInfo"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel?peer=peer0.ccd.example.com" \
#   -H "authorization: Bearer $ORG3_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

# echo "GET query Installed chaincodes"
# echo
# curl -s -X GET \
#   "http://localhost:4000/chaincodes?peer=peer0.airport.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

# echo "GET query Instantiated chaincodes"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels/mychannel/chaincodes?peer=peer0.airport.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

# echo "GET query Channels"
# echo
# curl -s -X GET \
#   "http://localhost:4000/channels?peer=peer0.airport.example.com" \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
