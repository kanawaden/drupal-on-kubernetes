#! /bin/bash

# Initialize helm
helm init --history-max 200 --service-account=tiller

# Adding Bitnami repo
helm repo add bitnami https://charts.bitnami.com

# Create service account for Tiller (helm server)
kubectl create serviceaccount -n kube-system tiller

# Create ClusterRoleBinding to attach role to tiller service account
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)
kubectl create clusterrolebinding tiller-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

# Tiller-deploy patched
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
