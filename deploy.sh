#!/bin/bash
set -e
username=username

docker pull mongo:latest
docker build -t ${username}/post:1.0 ./post-py
docker build -t ${username}/comment:1.0 ./comment
docker build -t ${username}/ui:1.0 ./ui

docker network create reddit
docker volume create reddit_db
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post ${username}/post:1.0
docker run -d --network=reddit --network-alias=comment ${username}/comment:1.0
docker run -d --network=reddit -p 9292:9292 ${username}/ui:1.0