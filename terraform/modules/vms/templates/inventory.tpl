---
all:
  hosts:
%{ for vm in vms ~}
    ${vm.name}:
      ansible_host: ${vm.public_ip}
      ansible_user: adminuser
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
      private_ip: ${vm.private_ip}
%{ endfor ~}
  vars:
    ansible_python_interpreter: /usr/bin/python3
