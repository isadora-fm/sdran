# Prerequisites
- docker
- helm
- k8s

## Docker Installation

```js
curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh
```

Docker without sudo:
```js
sudo usermod -aG docker $USER     

newgrp docker 
```
## Helm Installation

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh

```

## K8S cluster Installation

1. Add Kubernetes Signing Key
```js
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
```

2. Add Software Repositories
```js
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
```

3. Kubernetes Installation Tools
```js
sudo apt-get install kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl

```

4. disabling the swap memory on each server:
```js
sudo swapoff –a
```

5. Assign Unique Hostname for Each Server Node
```js
sudo hostnamectl set-hostname master-node
```

6. Initialize Kubernetes on Master Node
```js
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

7. to create a directory for the cluster:
```js
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
8. Deploy Pod Network to Cluster
```js
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

OBS: if the pod got tainted do:
```
kubectl taint nodes --all node-role.kubernetes.io/master:-
```


# Install SDRAN

```docker
# Update repositório helm
helm repo update

# Install atomix
helm install atomix-controller atomix/atomix-controller -n kube-system --version 0.6.9

helm install atomix-raft-storage atomix/atomix-raft-storage -n kube-system --version 0.1.25

# Install Onos-operator
helm install -n kube-system onos-operator onos/onos-operator --version 0.5.2

# Install ran-simulator e do onos-kpimon flags
helm -n sdran install sd-ran sdran/sd-ran --set import.ran-simulator.enabled=true --set import.onos-kpimon.enabled=true --set ran-simulator.pci.modelName=your-modal-name --version 1.4.2

helm install -n sdran onos-exporter sdran/onos-exporter --set import.fluent-bit.enabled=true --set import.opensearch.enabled=true --set import.prometheus-stack.enabled=true
```

`OBS`: Precisa realizar o seguinte ajuste devido o opensearch e em seguida restartar o docker:
```js
sysctl -w vm.max_map_count=262144
systemctl restart docker.service
```

## RANSim usando um modelo diferente
`obs: nao está funcionando dessa forma e está passando atraves da flag --set ran-simulator.pci.modelName=two-cell-two-node-model.`

Por default, o RANSim usa o model.yaml como arquivo modelo. Para usar um diferente específico deve-se:

Dentro do pod onos-cli executar:
```js
wget https://raw.githubusercontent.com/onosproject/sdran-helm-charts/master/ran-simulator/files/model/model-5cell-100ue.yaml


onos ransim load --data=/home/onos/model-5cell-100ue.yaml --data-name=model-5cell-100ue.yaml
```


## Links de referencia
- https://github.com/onosproject/onos-exporter

- https://github.com/onosproject/onos-helm-charts/tree/master/onos-umbrella