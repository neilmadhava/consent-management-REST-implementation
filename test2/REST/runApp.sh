#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

function dkcl(){
        CONTAINER_IDS=$(docker ps -aq)
	echo
        if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" = " " ]; then
                echo "========== No containers available for deletion =========="
        else
                docker rm -f $CONTAINER_IDS
        fi
	echo

	rm -r fabric-client-kv-airport
	rm -r fabric-client-kv-ccd
	rm -r fabric-client-kv-users
}


function restartNetwork() {
	echo

  #teardown the network and clean the containers and intermediate images
	docker-compose -f ../docker-compose-cli.yaml down
	dkcl

	#Cleanup the stores
	rm -rf ./fabric-client-kv-org*

	#Start the network
	docker-compose -f ../docker-compose-cli.yaml up -d
	echo
}

function installNodeModules() {
	echo
	if [ -d node_modules ]; then
		echo "============== node modules installed already ============="
	else
		echo "============== Installing node modules ============="
		npm install
	fi
	echo
}


restartNetwork

installNodeModules

PORT=4000 node app
