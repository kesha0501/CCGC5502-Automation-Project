# CCGC 5502 Automation Project

This repository contains the code for the CCGC 5502 Automation Project, implementing infrastructure as code with Terraform and configuration as code with Ansible on Microsoft Azure. Humber ID: n01736553.

## Directory Structure
- `ansible/`: Ansible playbook, inventory, and roles.
- `terraform/`: Terraform root and module files for Azure infrastructure.
- `docs/`: Screenshots and videos for submission.
- `keys/`: SSH keys fetched from VMs.

## Setup
1. Clone the repository: `git clone git@github.com:kesha0501/CCGC5502-Automation-Project.git`
2. Install Terraform, Ansible, and Azure CLI.
3. Authenticate with Azure: `az login`
4. Create Azure storage account `6553tfstate` and container `tfstate`.
5. Run `terraform init` and `terraform apply` in the `terraform/` directory.
6. Update `ansible/inventory.yml` with VM IPs from Terraform outputs.
7. Run the Ansible playbook: `ansible-playbook -i ansible/inventory.yml ansible/6553-playbook.yml`

## Tags
- Project: CCGC 5502 Automation Project
- Name: Kesha Shah
- ExpirationDate: 2024-12-31
- Environment: Project
