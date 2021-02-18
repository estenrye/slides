"""Role testing files using testinfra."""


def test_keepalived_conf_file(host):
    """Validate /etc/keepalived/keepalived.conf file."""
    f = host.file("/etc/keepalived/keepalived.conf")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"

def test_keepalived_check_file(host):
    """Validate /etc/keepalived/check_apiserver.sh file."""
    f = host.file("/etc/keepalived/check_apiserver.sh")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"

def test_haproxy_conf_file(host):
    """Validate /etc/haproxy/haproxy.cfg file."""
    f = host.file("/etc/haproxy/haproxy.cfg")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"

def test_haproxy_manifest_file(host):
    """Validate /etc/kubernetes/manifests/haproxy.yml file."""
    f = host.file("/etc/kubernetes/manifests/haproxy.yml")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"

def test_keepalived_manifest_file(host):
    """Validate /etc/kubernetes/manifests/keepalived.yml file."""
    f = host.file("/etc/kubernetes/manifests/keepalived.yml")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"
