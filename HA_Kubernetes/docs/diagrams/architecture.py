from diagrams import Cluster, Diagram, Edge
from diagrams.generic.network import Firewall, Router
from diagrams.k8s import controlplane, infra, compute
from diagrams.k8s.group import Namespace
from diagrams.k8s.network import Ingress, Service
from diagrams.onprem.certificates import CertManager, LetsEncrypt
from diagrams.onprem.client import Client, Users
from diagrams.onprem.container import Crio
from diagrams.onprem.database import MSSQL, PostgreSQL
from diagrams.onprem.dns import Coredns
from diagrams.onprem.monitoring import Grafana, PrometheusOperator, Prometheus, Thanos
from diagrams.onprem.network import Etcd, HAProxy, Internet, Nginx
from diagrams.saas.cdn import Cloudflare

with Diagram("Kubernetes Cluster Architecture", show=False):
  endUsers = [
    Users("Customers"),
    Users("Employees")
  ]
  
  letsencrypt = LetsEncrypt("LetsEncrypt CA")
  internet = Internet("Internet")
  endUsers >> internet
  
  
  

  with Cluster("Network Perimeter"):
    cloudflare = Cloudflare("Cloudflare\nDNS/WAF/CDN")
    firewall = Firewall("External Firewall")
    internet >> Edge(label="Inbound App Traffic :443", color="green") >> cloudflare
    firewall >> Edge(label="frontend: app-ingress, :443", color="green")
    cloudflare >> Edge(color="green") >> firewall
    letsencrypt >> Edge(label="queries\nexternal dns", color="blue") >> cloudflare

  with Cluster("Internal Network"):
    employees = Users("Employees\nkubectl/calicoctl/helm")

    with Cluster("Cluster Load Balancers"):
      vip = Router("Virtual IP\n10.5.99.20")
      haproxy = [ HAProxy("haproxy01\n10.5.99.18"), HAProxy("haproxy02\n10.5.99.19")]
      vip - haproxy
      [ firewall, employees ] >> Edge(label="frontend: app-ingress, :443", color="green") >> vip
      employees >> Edge(label="frontend: kube-api, :6443", color="orange") >> vip
      vip >> Edge(label="backend: app-ingress, :32443", color="green")
    with Cluster("Kubernetes Cluster"):
      nodeIPs = [ "node01\n10.5.99.31", "node02\n10.5.99.32", "node03\n10.5.99.33"]
      controlplaneIPs = ["controlplane01\n10.5.99.21", "controlplane02\n10.5.99.22", "controlplane03\n10.5.99.23"]
      kubelets = []
      for node in nodeIPs:
        with Cluster(node):
          kubelet = controlplane.Kubelet(":10250")
          kubelets.append(kubelet)
      with Cluster("Kubernetes Controlplane"):
        apiservers = []
        etcdservers = []
        for ip in controlplaneIPs:
          with Cluster(ip):
            kubelet = controlplane.Kubelet(":10250")
            kubelets.append(kubelet)
            with Cluster("Namespace: kube-system"):
              apiserver = controlplane.APIServer(":6443")
              apiservers.append(apiserver)
              etcd = infra.ETCD(":2379, :2380")
              for etcdserver in etcdservers:
                etcd - Edge(label=":2380", color="black") - etcdserver
              etcdservers.append(etcd)
              sched = controlplane.Scheduler(":10251")
              sched >> Edge(label=":6443", color="black") >> apiserver
              controllermanager = controlplane.ControllerManager(":10252")
              controllermanager >> Edge(label=":6443", color="black") >> apiserver
              coredns = Coredns("coredns")
              apiserver >> Edge(label=":2379", color="black") >> etcd
              vip >> Edge(label="backend: kube-api, :6443", color="orange") >> apiserver
        with Cluster("Namespace: kube-system"):
          kubedns = Service("kube-dns") >> compute.Deployment("coredns") >> compute.ReplicaSet("coredns-replica-set")
