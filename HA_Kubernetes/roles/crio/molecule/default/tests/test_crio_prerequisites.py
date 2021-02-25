from utils import assert_apt_key
from utils import assert_apt_repository
from utils import assert_file
from utils import assert_module_loaded

def test_crio_module_load_d_conf_file(host):
  assert_file(host, "/etc/modules-load.d/crio.conf", "root", "root")

def test_crio_sysctl_d_conf_file(host):
  assert_file(host, "/etc/sysctl.d/99-kubernetes-cri.conf", "root", "root")

def test_crio_conf_file(host):
  assert_file(host, "/etc/crio/crio.conf.d/02-cgroup-manager.conf", "root", "root")

def test_modules_present(host):
  assert host.file("/etc/modules-load.d/crio.conf").contains("overlay\n")
  assert host.file("/etc/modules-load.d/crio.conf").contains("br_netfilter\n")
  assert_module_loaded(host, "overlay")
  assert_module_loaded(host, "br_netfilter")

def test_sysctl_conf(host):
  assert host.sysctl("net.bridge.bridge-nf-call-iptables") == 1
  assert host.sysctl("net.bridge.bridge-nf-call-ip6tables") == 1
  assert host.sysctl("net.ipv4.ip_forward") == 1

def test_apt_repositories(host):
  os = "xUbuntu_20.04"
  version = "1.20"

  path = "/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
  repository = f"deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/{ os }/ /"
  assert_apt_repository(host, path, repository)

  path = f"/etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:{ version }.list"
  repository = f"deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/{ version }/{ os }/ /"
  assert_apt_repository(host, path, repository)

def test_apt_keys(host):
  assert_apt_key(host, "/etc/apt/trusted.gpg.d/libcontainers.gpg", "2472D6D0D2F66AF87ABA8DA34D64390375060AA4")
  assert_apt_key(host, "/etc/apt/trusted.gpg.d/libcontainers-cri-o.gpg", "2472D6D0D2F66AF87ABA8DA34D64390375060AA4")

def test_crio_installed(host):
  assert host.package("cri-o").is_installed
  assert host.package("cri-o-runc").is_installed

def test_crio_service_is_running(host):
  service = host.service("crio")

  assert service.is_running
  assert service.is_enabled
  assert host.socket("unix:///var/run/crio/crio.sock").is_listening


