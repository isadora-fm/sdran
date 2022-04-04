reset-atomix:
	helm uninstall atomix-controller -n kube-system || true
	helm uninstall atomix-memory-storage -n kube-system || true
	helm uninstall atomix-raft-storage -n kube-system || true
	helm uninstall raft-storage-controller -n kube-system || true
	helm uninstall cache-storage-controller -n kube-system || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/kubernetes-controller/0a9e82ef37df25cf567a4dbc18f35b2bb454bda1/deploy/atomix-controller.yaml || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/raft-storage-controller/668951dff14e339f3c71b489863cbca8ec326a96/deploy/raft-storage-controller.yaml || true
	kubectl delete -f https://raw.githubusercontent.com/atomix/cache-storage-controller/85014c6216e3d8cdf22df09aab3d1f16852fc584/deploy/cache-storage-controller.yaml || true
	for i in $$(kubectl get crd --no-headers --all-namespaces | grep atomix | awk '{print $$1}'); do for j in $$(kubectl get $$i --no-headers -n kube-system | awk '{print $$1}'); do kubectl patch $$i/$$j -n kube-system --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; for k in $$(kubectl get $$i --no-headers -n sdran | awk '{print $$1}'); do kubectl patch $$i/$$k -n sdran --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; kubectl delete crd $$i || true; done
	cd $(M); rm -f atomix

reset-onos-op:
	helm uninstall onos-operator -n kube-system || true
	for i in $$(kubectl get crd --no-headers --all-namespaces | grep onos | awk '{print $$1}'); do for j in $$(kubectl get $$i --no-headers -n kube-system | awk '{print $$1}'); do kubectl patch $$i/$$j -n kube-system --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; for k in $$(kubectl get $$i --no-headers -n sdran | awk '{print $$1}'); do kubectl patch $$i/$$k -n sdran --type=merge --patch '{"metadata":{"finalizers":[]}}' || true; done; kubectl delete crd $$i || true; done
	cd $(M); rm -f onos-operator