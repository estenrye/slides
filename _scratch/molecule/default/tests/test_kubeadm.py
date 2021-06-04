from utils import assert_apt_key
from utils import assert_apt_repository

def test_kubernetes_apt_keys(host):
  assert_apt_key(host, "/etc/apt/trusted.gpg.d/google_cloud_packages.gpg", "54A647F9048D5688D7DA2ABE6A030B21BA07F4FB")

def test_kubernetes_repository(host):
  assert_apt_repository(host, "/etc/apt/sources.list.d/kubernetes.list", "deb https://apt.kubernetes.io/ kubernetes-xenial main")

def test_kubeadm_installed(host):
  assert host.package("kubelet").is_installed
  assert host.package("kubeadm").is_installed
  assert host.package("kubectl").is_installed
