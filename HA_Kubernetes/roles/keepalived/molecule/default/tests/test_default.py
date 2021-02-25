"""Role testing files using testinfra."""
from utils import assert_directory
from utils import assert_file

def test_hosts_file(host):
    """Validate /etc/hosts file."""
    f = host.file("/etc/hosts")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"

def test_keepalived_conf_directory(host):
    assert_directory(host, "/etc/keepalived", "root", "root")

def test_keepalived_conf_files(host):
    assert_file(host, "/etc/keepalived/keepalived.conf", "root", "root")
    assert_file(host, "/etc/keepalived/check_apiserver.sh", "root", "root")
