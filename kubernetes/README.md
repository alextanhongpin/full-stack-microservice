This does not cover the installation for kubernetes. 

To start kubernetes:
```bash
$ minikube start --vm-driver=xhyve
```

Set the context for `kubectl` to use `minikube` cluster:
```bash
$ kubectl config use-context minikube
```

Verify that `kubectl` is configured to communicate with your cluster:

```bash
$ kubectl cluster-info
```

Access dashboard using the kubectl command-line tool:
```bash
$ kubectl proxy
$ open http://127.0.0.1:8001/ui
```

To stop minikube:

```bash
$ minikube stop
```

To install kubeless:

```bash
$ brew install kubeless/tap/kubeless
$ KUBELESS_VERSION=0.1.0
$ kubectl create ns kubeless
$  curl -sL https://github.com/kubeless/kubeless/releases/download/v$KUBELESS_VERSION/kubeless-v$KUBELESS_VERSION.yaml | kubectl create -f -
```