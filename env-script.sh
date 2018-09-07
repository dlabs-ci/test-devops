#!/bin/bash
. ./.env
cat .env | while read line; do
	echo $line
done
