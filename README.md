# CCGC 5502 Automation Project
**Student**: Kesha Shah (6553)

## Overview
This project automates the deployment of 3 Azure VMs with a load balancer using Terraform and configures them with Ansible for CCGC 5502.

## Terraform Setup
- Initialize: `cd terraform && terraform init`
- Apply: `terraform apply main.tfplan`
- Outputs: `terraform output vm_public_ips`, `terraform output loadbalancer_public_ip`
- Resources: 48 (verified via `terraform state list | nl`)

## Ansible Setup
- Inventory: `ansible/inventory.yml` (VM public IPs: 4.206.74.73, 4.206.32.161, 4.206.32.113)
- Playbook: `ansible/6553-playbook.yml`
- Roles:
  - `datadisk-6553`: Formats and mounts 10GB data disk at `/mnt/data`.
  - `user-6553`: Creates `student` user with SSH key-based login.
  - `profile-6553`: Sets environment variables in `/etc/profile.d/6553.sh`.
  - `webserver-6553`: Installs Apache, serves unique HTML pages (`vm1.html`, `vm2.html`, `vm3.html`).
- Run: `cd ansible && ansible-playbook -i inventory.yml 6553-playbook.yml`

## Validation
- Disk: `ansible -i inventory.yml all -m shell -a "lsblk"` and `df -h /mnt/data`
- User: `ansible -i inventory.yml all -m shell -a "id student"`; SSH key login (`ssh -i ../backup_ssh_keys/id_rsa student@<IP>`)
- Profile: `ansible -i inventory.yml all -m shell -a "cat /etc/profile.d/6553.sh"` and `. /etc/profile.d/6553.sh && echo $STUDENT_ID`
- Web Server: `curl http://<loadbalancer_public_ip>`
- Screenshots: `docs/screenshots/*.png`, `*.mp4`

## Repository
- GitHub: `git@github.com:kesha0501/CCGC5502-Automation-Project.git`
