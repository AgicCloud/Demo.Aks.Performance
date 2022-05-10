## Installazione di Prometheus stack
Per installare Prometheus e Grafana ho usato l'helm chart [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md)

Ho customizzato un file dei valori, in modo da avere l'app che risponde sulla root e grafana sul path /grafana, ad esempio
```
http://51.124.140.62/ <- app
http://51.124.140.62/grafana/ <- grafana
```

```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace prometheus
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack --values prometheus.values.demo.yaml --wait --debug --atomic --timeout 600s
```

Per accedere a Grafana si usa
```
User: admin
Pass: <sta nel file prometheus.values.demo.yaml>
```

## Disinstallazione
```console
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
helm delete prometheus-stack
```