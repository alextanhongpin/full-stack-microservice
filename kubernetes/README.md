This does not cover the installation for kubernetes. 

To start kubernetes with xhyve (default is Virtualbox):
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

## Deploying a nodejs app

Required so that you can use your local docker image
```bash
# Allow local docker image
$ eval $(minikube docker-env)

# To unset it
$ eval $(minikube docker-env -u)
```

Create a new deployment:

```bash
$ kubectl run kube-node --image=alextanhongpin/kube-node:v1 --port=8080
```

View the deployment:

```bash
$ kubectl get deployments
```

Output:

```bash
NAME        DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-node   1         1         1            0           7s
```

View the pods:

```bash
$ kubectl get pods
```

Output:
```
NAME                         READY     STATUS             RESTARTS   AGE
kube-node-1460685109-dttq2   0/1       ImagePullBackOff   0          2m
```

Usually in case of "ImagePullBackOff" it's retried after few seconds/minutes. In case you want to try again manually you can delete the old pod and recreate the pod.
```
$ kubectl delete pods wso2am-default-813fy
$ kubectl create -f <yml_file_describing_pod>
```

Deploy the service:

```bash
$ kubectl expose deployment kube-node --type=LoadBalancer
```

View the Service you just created:

```bash
$ kubectl get services
```

Output:
```bash
NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
kube-node    10.0.0.43    <pending>     8080:32234/TCP   1m
kubernetes   10.0.0.1     <none>        443/TCP          40d
```

Open the service:

```bash
$ minikube service kube-node
```

Get the service logs:
```bash
$ kubectl logs <POD-NAME>
```

Delete the service

```bash
$ kubectl delete service kube-node
$ kubectl delete deployment kube-node
```