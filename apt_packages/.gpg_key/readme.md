## References ##

- https://www.internalpointers.com/post/build-binary-deb-package-practical-guide

## Storing gpg passphrase

```bash
ansible-vault create --vault-id creds@prompt ~/.ansible_creds.yml
```

This vault should contain:

```yaml
gpg_passphrase: 'your-passphrase-here'
```

## Build Process

```bash
ansible-playbook -e @~/.ansible_creds.yml --ask-vault-pass -i localhost, generate_key.yml
```
