#! /bin/bash

helm delete $1

helm del --purge $1
