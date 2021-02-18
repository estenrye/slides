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

def assert_module_loaded(host, module_name):
  command = f"modprobe --dry-run --first-time --quiet '{ module_name }' && echo 'not_loaded' || echo 'loaded'"
  actual = host.run(command)

  assert actual.stdout == "loaded\n"
