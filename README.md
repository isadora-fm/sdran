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