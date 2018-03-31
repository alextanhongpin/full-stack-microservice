# Conduit

## Start Minikube

```bash
$ minikube start --kubernetes-version=v1.9.4 --extra-config=apiserver.Authorization.Mode=RBAC
```
## Install

```bash
$ curl https://run.conduit.io/install | sh
```

## Setup Path

Edit your `.zshrc` or `.bashrc`:

```bash
export PATH=$HOME/.conduit/bin:$PATH
```

## Fix RBAC in Minikube

```bash
$ kubectl create -f rbac.yml
```

## Install Conduit

```bash
$ conduit install | kubectl apply -f -
```

## Delete 

```bash
$ conduit install | kubectl delete -f -
```

Output:

```
namespace "conduit" created
serviceaccount "conduit-controller" created
clusterrole "conduit-controller" created
clusterrolebinding "conduit-controller" created
serviceaccount "conduit-prometheus" created
clusterrole "conduit-prometheus" created
clusterrolebinding "conduit-prometheus" created
service "api" created
service "proxy-api" created
deployment "controller" created
service "web" created
deployment "web" created
service "prometheus" created
deployment "prometheus" created
configmap "prometheus-config" created
service "grafana" created
deployment "grafana" created
configmap "grafana-config" created
configmap "grafana-dashboards" created
```

## Verify

```bash
$ conduit check
```
Output:

```bash
kubernetes-api: can initialize the client.......................................[ok]
kubernetes-api: can query the Kubernetes API....................................[ok]
kubernetes-api: is running the minimum Kubernetes API version...................[ok]
conduit-api: can query the Conduit API..........................................[ok]
conduit-api[telemetry]: control plane can use telemetry service.................[ok]
conduit-version: cli is up-to-date..............................................[ok]
conduit-version: control plane is up-to-date....................................[ok]
```

## Dashboard

```
$ conduit dashboard
```

Output:

```bash
Conduit dashboard available at:
http://127.0.0.1:59488/api/v1/namespaces/conduit/services/web:http/proxy/
Opening the default browser
Starting to serve on 127.0.0.1:59488
```

![assets/conduit.png](assets/conduit.png)

## Create Deployment

```bash
$ conduit inject deployment.yml | kubectl apply -f -
```

