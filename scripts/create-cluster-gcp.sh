#! /bin/bash

# Creating a network
gcloud compute networks create cms

# Create Cluster
gcloud container clusters create drupal-cluster \
  --network cms --machine-type n1-standard-2 --num-nodes 2 \
  --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw,cloud-platform"
