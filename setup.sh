#!/bin/sh
minikube delete
minikube start --cpus 4 --memory 8192
kubectl create secret generic eh-secrets --from-env-file=./secrets.txt
kubectl apply -f ./k8s/persistent
skaffold dev
