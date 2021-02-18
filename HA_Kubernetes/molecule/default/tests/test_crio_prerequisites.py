from utils import assert_file
from utils import assert_module_loaded

def test_crio_module_load_d_conf_file(host):
    assert_file(host, "/etc/modules-load.d/crio.conf", "root", "root")

def test_crio_sysctl_d_conf_file(host):
    assert_file(host, "/etc/sysctl.d/99-kubernetes-cri.conf", "root", "root")

def test_modules_present(host):
  assert host.file("/etc/modules-load.d/crio.conf").contains("overlay\n")
  assert host.file("/etc/modules-load.d/crio.conf").contains("br_netfilter\n")
  assert_module_loaded(host, "overlay")
  assert_module_loaded(host, "br_netfilter")

def test_sysctl_conf(host):
  assert host.sysctl("net.bridge.bridge-nf-call-iptables") == 1
  assert host.sysctl("net.bridge.bridge-nf-call-ip6tables") == 1
  assert host.sysctl("net.ipv4.ip_forward") == 1

