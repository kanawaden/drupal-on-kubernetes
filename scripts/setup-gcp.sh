#! /bin/bash

# Set the default project to drupal-platform
gcloud config set project drupal-platform

# Set the default Compute Engine zone to asia-southeast1-a
gcloud config set compute/zone asia-southeast1-a

# Set the default Compute Engine region to asia-southeast1
gcloud config set compute/region asia-southeast1

# Update gcloud to the latest version
gcloud components update
