#!/usr/bin/env bash

./uninstall-services.sh

kubectl delete --namespace dev -f deployment-files/bookservice-deployment.yaml
kubectl delete secrets --namespace dev book-service-db

kubectl delete namespace dev
