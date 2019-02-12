#!/bin/bash
#
# Author: David Vidal Villamide (aka askhari)
# Description:
# This kill prepare your kubernetes cluster to install kubeapps in its own namespace.

kubectl create serviceaccount kubeapps-operator serviceaccount/kubeapps-operator created
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=kubeapps:kubeapps-operator clusterrolebinding.rbac.authorization.k8s.io/kubeapps-operator created
kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{.secrets[].name}') -o jsonpath='{.data.token}' | base64 --decode

