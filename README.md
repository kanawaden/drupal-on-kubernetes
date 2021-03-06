# Drupal-MySQL on Kubernetes Using Helm

[Drupal](https://www.drupal.org/) is one of the most versatile open source content management systems on the market.

[MySQL](https://www.mysql.com/) is an open source relational database management system.

This code is platform agnostic so can be use to install in local, on premise or any cloud.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- Helm

## Installing minikube in MAC

From Root directory of this repo, execute below command:
```console
sh ./scripts/install-minikube-mac.sh
```

OR

Follow below link to install manually
https://kubernetes.io/docs/tasks/tools/install-minikube/

1. use brew to install minikube
```console
brew cask install minikube
```

2. Once the above installation is successful then start minikube.
```console
minikube start
```

## Installing kubectl and helm in MAC

From Root directory of this repo, execute below command:
```console
sh ./scripts/install-tools-mac.sh
```

OR

Follow below link to install manually
1. Install kubectl
```console
brew install kubernetes-cli
```

2. Install Helm client
```console
brew install kubernetes-helm
```

## Solution

There are 2 implementation of Drupal using MySQL in Kubernetes covered in this repo.
1. Using existing stable package from the makers of kubernetes. (repo: https://kubernetes-charts.storage.googleapis.com/)
2. Custom Chart which is create manually.

Before looking into exact installation steps using Helm, we need to prepare the environment. For that we have to create kubernetes cluster and prepare helm to work on it.


### Create Kubernetes Cluster

In minikube, use below command:
```console
minikube start
```

In GCP, cluster can be created using console and commandline.

For console, visit GCP and follow steps from below link:
https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster

To create a cluster from command line execute below script.
```console
sh ./scripts/setup-gcp.sh

sh ./scripts/create-cluster-gcp.sh
```

### Prepare Helm
Before installing helm charts, helm environment needs to be prepared. For that initialized helm, create service account for tiller and create ClusterRoleBinding to attach to tiller.

```console
sh ./scripts/prepare-helm.sh
```

### Installing the Chart - Using stable charts

To install the mysql chart with release name `mysql`:
```console
helm install --values ./helm/using-stable-charts/mysql/values.yaml --name mysql stable/mysql
```

To install the drupal chart with the release name `drupal`:

```console
helm install --values ./helm/using-stable-charts/drupal/values.yaml --name drupal stable/drupal
```

Note: I have already overridden default values of this charts. Please refer to respective values.yaml for more detail.

### Installing the Chart - Using custom charts

To install the drupal chart with release name `drupal`:
```console
helm install --name drupal ./helm/custom-charts/drupal
```

### Accessing drupal

1. Get the Drupal URL:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.

```console
export SERVICE_IP=$(kubectl get svc --namespace default drupal-drupal --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")

echo "Drupal URL: http://$SERVICE_IP/"
```
2. Login with the following credentials

```console
echo Username: user
echo Password: $(kubectl get secret --namespace default drupal-drupal -o jsonpath="{.data.drupal-password}" | base64 --decode)
```

3. Open Drupal URL in browser and login via above credentials.
![Drupal Home Page](assets/images/drupal-home.png "Drupal Home Page")

## Uninstalling the Chart

To uninstall/delete the deployment:

```console
$ helm delete <release-name>
```

Use below purge command to remove all the records of the deployment.
```console
helm del --purge <release name>
```
