sudo pip3 install --no-warn-script-location -r /install/requirements.txt
ansible-galaxy install -r /install/requirements.yml
ansible-playbook -i localhost,chroot /ansible/customize-iso_from-scratch.yml
