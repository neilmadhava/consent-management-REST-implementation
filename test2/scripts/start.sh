#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
# SCRIPT FOR GENERATING CERTIFICATES AND ARTIFACTS

# export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH="$PWD"
CHANNEL_NAME=mychannel
SYS_CHANNEL=byfn-sys-channel

# remove previous crypto material and config transactions
# rm -fr config/*
# rm -fr crypto-config/*

# generate crypto material
# cryptogen generate --config=./crypto-config.yaml

# if [ "$?" -ne 0 ]; then
# 	echo "Failed to generate crypto material..."
# 	exit 1
# fi


# generate genesis block for orderer
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
echo + configtxgen -profile TwoOrgsOrdererGenesis -channelID $SYS_CHANNEL -outputBlock ./channel-artifacts/genesis.block

configtxgen -profile TwoOrgsOrdererGenesis -channelID $SYS_CHANNEL -outputBlock ./channel-artifacts/genesis.block
if [ "$?" -ne 0 ]; then
	echo "Failed to generate orderer genesis block..."
	exit 1
fi

# generate channel configuration transaction
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
echo + configtxgen -profile ACUChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME


configtxgen -profile ACUChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

if [ "$?" -ne 0 ]; then
	echo "Failed to generate channel configuration transaction..."
	exit 1
fi

# generate anchor peer transaction
echo "#################################################################"
echo "#######    Generating anchor peer update for airport   ##########"
echo "#################################################################"
echo + configtxgen -profile ACUChannel -outputAnchorPeersUpdate ./channel-artifacts/airportanchors.tx -channelID $CHANNEL_NAME -asOrg airport

configtxgen -profile ACUChannel -outputAnchorPeersUpdate ./channel-artifacts/airportanchors.tx -channelID $CHANNEL_NAME -asOrg airport
if [ "$?" -ne 0 ]; then
	echo "Failed to generate anchor peer update for CCD..."
	exit 1
fi

# generate anchor peer transaction
echo
echo "#################################################################"
echo "#######    Generating anchor peer update for ccd       ##########"
echo "#################################################################"
echo + configtxgen -profile ACUChannel -outputAnchorPeersUpdate ./channel-artifacts/ccdanchors.tx -channelID $CHANNEL_NAME -asOrg ccd

configtxgen -profile ACUChannel -outputAnchorPeersUpdate ./channel-artifacts/ccdanchors.tx -channelID $CHANNEL_NAME -asOrg ccd

if [ "$?" -ne 0 ]; then
	echo "Failed to generate anchor peer update for Airport..."
	exit 1
fi

# generate anchor peer transaction
echo
echo "#################################################################"
echo "#######    Generating anchor peer update for users     ##########"
echo "#################################################################"
echo + configtxgen -profile ACUChannel -outputAnchorPeersUpdate ./channel-artifacts/usersanchors.tx -channelID $CHANNEL_NAME -asOrg users

configtxgen -profile ACUChannel -outputAnchorPeersUpdate ./channel-artifacts/usersanchors.tx -channelID $CHANNEL_NAME -asOrg users

if [ "$?" -ne 0 ]; then
	echo "Failed to generate anchor peer update for Airport..."
	exit 1
fi

./scripts/ccp-generate.sh