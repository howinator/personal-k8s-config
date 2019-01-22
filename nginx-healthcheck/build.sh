#!/usr/bin/env bash

docker build -t howinator/nginx-healthcheck .
docker push howinator/nginx-healthcheck
