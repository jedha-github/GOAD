# GOAD on AWS

This is based on the works of [jarrault](https://github.com/jarrault/GOAD/tree/azure/ad/azure-sevenkingdoms.local) and [0xBallPoint](https://github.com/0xBallpoint/LOAD).

## Pre-requisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

## Setup

### AWS CLI

You will need to configure your AWS CLI with your credentials. You can do this by running `aws configure` and entering your credentials.

<!-- TODO add the configuration and why -->

### Create SSH Key

Let's generate a key pair to connect to the instances:

```bash
$ cd ad/aws-sevenkingdoms.local
$ ssh-keygen -t rsa -N "" -b 2048 -C "TerraformKey" -f ./terraform/keys/TerraformKey
```

### Terraform

We need to generate a password in order to connect to Windows instances. You can do this by running the following command:

```bash
$ cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 30 # for Linux
$ cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 30 | head -n 1 # for MacOS
```

Keep it safe, you will need it later.

In `ad/aws-sevenkingdoms.local/terraform/scripts/`, replace `<PASSWORD>` with the previous password and run the following command:

```bash
$ sed "s/__PASSWORD__/<PASSWORD>/g" ansibleuserdata.ps1.template > ansibleuserdata.ps1
```

It generates a script that will be executed on the Windows instances to install Ansible and configure WinRM.

To initialize terraform, run the following command in `ad/aws-sevenkingdoms.local/terraform` (should be done only once):

```bash
$ terraform init
```

Plan and validate the terraform configuration:

```bash
$ terraform plan
$ terraform validate
```

Apply the terraform configuration:

```bash
$ terraform apply
```

### Ansible

Connect to the admin server:

```bash
$ ssh -i ./terraform/keys/TerraformKey ubuntu@<ADMIN_SERVER_IP>
```

On the admin server, if everything went you should see the `GOAD` directory:

```bash
$ ls
GOAD
```

You need to update the `ad/aws-sevenkingdoms.local/inventory` file with your password (you can retrieve it by looking at `ad/aws-sevenkingdoms.local/terraform/scripts/ansibleuserdata.ps1` on your local machine 😉):

```
ansible_password=YourSecretPassword
```

Ansible is already setup on admin server. You just need to activate the Python virtual environment:

```bash
$ cd GOAD/ansible
$ source .venv/bin/activate
```

You can use `screen` so as to keep the session alive even if you disconnect:

```bash
$ screen -S ansible
```

Then, in the `ansible` directory:

```bash
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory build.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-servers.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-trusts.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-data.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory laps.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-relations.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory adcs.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-acl.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory servers.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory security.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory vulnerabilities.yml
```
