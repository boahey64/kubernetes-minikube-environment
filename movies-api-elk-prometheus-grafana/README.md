# kubernetes-minikube-environment
## `> movies-api-elk-prometheus-grafana`

The goal of this example is to create a `Helm Chart` for the [`Spring Boot`](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/) application [`movies-api`](https://github.com/ivangfr/springboot-elk-prometheus-grafana#application). Then, the chart will be used to install the application in [`Kubernetes`](https://kubernetes.io) ([`Minikube`](https://kubernetes.io/docs/getting-started-guides/minikube)).

As `movies-api` uses `MySQL` as storage, this database will also be installed using its `Helm Chart`. Besides, other services used in this example like `Elasticsearch`, `Logstash`, `Kibana`, `Prometheus-Operator`, etc, will be installed using their respective `Helm Charts`.

## Clone example repository

- Open a terminal

- Run the following command to clone [`springboot-elk-prometheus-grafana`](https://github.com/ivangfr/springboot-elk-prometheus-grafana)
  ```
  git clone https://github.com/ivangfr/springboot-elk-prometheus-grafana.git
  ```

## Start Minikube

First, start `Minikube` as explained in [Start Minikube](https://github.com/ivangfr/kubernetes-minikube-environment#start-minikube)

## Build Docker Image

- In a terminal, navigate to `springboot-elk-prometheus-grafana` root folder

- Set `Minikube` host
  ```
  eval $(minikube docker-env)
  ```

- Build `movies-api` Docker image. For it, run the following command
  ```
  ./docker-build.sh
  ```

- Get back to Host machine Docker Daemon   
  ```
  eval $(minikube docker-env -u)
  ```

## Create a namespace

- In a terminal, run the following command to create a new namespace called `dev`
  ```
  kubectl create namespace dev
  ```
  > To delete run
  > ```
  > kubectl delete namespace dev
  > ```

- \[Optional\] To list all namespaces run
  ```
  kubectl get namespaces
  ```

## Install services

- In a terminal, navigate to `kubernetes-minikube-environment/movies-api-elk-prometheus-grafana` folder

- To install the services, run the script below
  ```
  ./install-services.sh
  ```
  > To uninstall run
  > ```
  > ./uninstall-services.sh
  > ```

  It will install `MySQL`, `Elasticsearch`, `Logstash`, `Kibana`, `Filebeat`, `Prometheus-Operator` and `Grafana`. This process will take time because it involves pulling service's docker images and starting them.

- Watch the status/progress of the service's installation
  ```
  kubectl get pods --namespace dev --watch
  ```
  > To stop watching, press `Ctrl+C`

## Install application

- In a terminal, make sure you are in `kubernetes-minikube-environment/movies-api-elk-prometheus-grafana` folder

- Install `movies-api`
  ```
  helm install movies-api --namespace dev my-charts/movies-api
  ```
  > To delete run
  > ```
  > helm delete --namespace dev movies-api
  > ```

## Application & Services URLs

- In a terminal, make sure you are inside `kubernetes-minikube-environment/movies-api-elk-prometheus-grafana` folder

- Run the command below to get application and services URLs
  ```
  ./get-application-services-urls.sh
  ```

## Services Configuration

- **Kibana**

  - Access `Kibana` website
  - Click `Explore on my own`
  - In the main Kibana page, click the _"burger"_ menu icon and, then click `Discover`
  - Click `Create index pattern` button
  - In the `Index pattern name` field, set `filebeat-*` and click `> Next Step` button
  - In the `Time field` combo-box, select `@timestamp` and click `Create index pattern`
  - Click the _"burger"_ menu icon again and then, click `Discover` to start performing searches

- **Prometheus**

  While installing `movies-api` Helms Chart at [Install application](#install-application), a `Service Monitor` is configured. It calls application's `prometheus` endpoint in order to collect some metrics.

  We can check whether the `Service Monitor` is configured correctly by
  - Access `Prometheus` website
  - Click `Status` dropdown menu and, then click `Targets`
  - The `movies-api` reference should be displayed and its status must be `UP`
  
- **Grafana**

  - Access `Grafana` website
  - Login using username `admin` and password `admin`
  - Skip the next screen in case you don't want to change the credentials
  - In the main Grafana page, hover mouse over the `Gear` icon and click `Data source` submenu
  - Click `Add data source` button
  - Select `Prometheus`
  - In the `HTTP` section, set `my-kube-prometheus-operator:9090` to the `URL` field
  - Click `Save & Test` button. A green message saying `Data source is working` should appear
  - Click `+` icon on the menu and start creating a new dashboard 

## Cleanup

- In a terminal, make sure you are in `kubernetes-minikube-environment/movies-api-elk-prometheus-grafana` folder

- Run the script below to uninstall all services, `movies-api` application and `dev` namespace.
  ```
  ./cleanup.sh
  ```

## TODO

- It would be nice to have `Prometheus` automatically set as data source in `Grafana`. Also predefined Dashboards. Waiting for this issue to be solved, https://github.com/bitnami/charts/issues/7680
