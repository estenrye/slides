"""Role testing files using testinfra."""

def assert_directory(host, dir, user, group):
    f = host.file(dir)

    assert f.exists
    assert f.is_directory
    assert f.user == user
    assert f.group == group

def assert_file(host, file, user, group):
    f = host.file(file)

    assert f.exists
    assert f.is_file
    assert f.user == user
    assert f.group == group

def test_keepalived_conf_directory(host):
    assert_directory(host, "/etc/keepalived", "root", "root")

def test_haproxy_conf_directory(host):
    assert_directory(host, "/etc/haproxy", "root", "root")

def test_modules_load_d_conf_directory(host):
    assert_directory(host, "/etc/modules-load.d", "root", "root")

def test_sysctl_d_conf_directory(host):
    assert_directory(host, "/etc/sysctl.d", "root", "root")

def test_kubernetes_conf_directory(host):
    assert_directory(host, "/etc/kubernetes", "root", "root")
    assert_directory(host, "/etc/kubernetes/manifests", "root", "root")

def test_keepalived_conf_files(host):
    assert_file(host, "/etc/keepalived/keepalived.conf", "root", "root")
    assert_file(host, "/etc/keepalived/check_apiserver.sh", "root", "root")

def test_haproxy_conf_file(host):
    assert_file(host, "/etc/haproxy/haproxy.cfg", "root", "root")

def test_kubernetes_manifest_file(host):
    assert_file(host, "/etc/kubernetes/manifests/keepalived.yml", "root", "root")
    assert_file(host, "/etc/kubernetes/manifests/haproxy.yml", "root", "root")

def test_crio_module_load_d_conf_file(host):
    assert_file(host, "/etc/modules-load.d/crio.conf", "root", "root")

def test_crio_module_load_d_conf_file(host):
    assert_file(host, "/etc/sysctl.d/99-kubernetes-cri.conf", "root", "root")
