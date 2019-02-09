# Tiller permission configuration

In order to allow tiller to manage our k8s cluster we create:

* A namespace to deploy tiller.
* A ClusterRoleBinding as a cluster-admin.

We have restricted the access to tiller using certificates, so only the helm client with the right certificate will be able to interact with helm.
