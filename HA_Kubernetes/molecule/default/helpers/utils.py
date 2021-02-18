def assert_directory(host, path, user, group):
    f = host.file(path)

    assert f.exists
    assert f.is_directory
    assert f.user == user
    assert f.group == group

def assert_file(host, path, user, group):
    f = host.file(path)

    assert f.exists
    assert f.is_file
    assert f.user == user
    assert f.group == group

def assert_module_loaded(host, module_name):
  command = f"modprobe --dry-run --first-time --quiet '{ module_name }' && echo 'not_loaded' || echo 'loaded'"
  actual = host.run(command)

  assert actual.stdout == "loaded\n"

def assert_apt_repository(host, path, repository):
    assert_file(host, path, "root", "root")

    f = host.file(path)

    assert f.contains(f"{ repository }\n")

def assert_apt_key(host, keyring_path, key_id):
    assert_file(host, keyring_path, "root", "root")

    assert not host.ansible("apt_key", f"keyring={ keyring_path } id={ key_id } state=present")["changed"]
