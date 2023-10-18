# GOAD on AWS

This is based on the works of [jarrault](https://github.com/jarrault/GOAD/tree/azure/ad/azure-sevenkingdoms.local) and [0xBallPoint](https://github.com/0xBallpoint/LOAD).

## Pre-requisites

Be sure to have the following tools installed on your machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

## Setup

### Terraform

#### Pre-requisites

##### Create SSH Key

Let's generate a key pair to connect to the instances:

```bash
$ cd ad/aws-sevenkingdoms.local
$ ssh-keygen -t rsa -N "" -b 2048 -C "TerraformKey" -f ./terraform/keys/TerraformKey
```

##### Configure AWS CLI

In your AWS account management interface, create a `terraform` user with programmatic access and attach the `EC2FullAccess` and `IAMFullAccess` policy to it. Then, configure your AWS CLI with the credentials of this user as Terraform will use it to create the instances.

##### Generate a password

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

It generates a script that will be executed on the Windows instances to install Ansible and configure WinRM. It also create a user `ansible` with the password you generated earlier.

#### Deployment

To initialize terraform, run the following command in `ad/aws-sevenkingdoms.local/terraform` (should be done only once):

```bash
$ terraform init
```

Plan and validate the terraform configuration (not necessary but recommended if you are editing the configuration):

```bash
$ terraform plan
$ terraform validate
```

Apply the terraform configuration:

```bash
$ terraform apply
```

### Ansible

#### Create configuration files

1. We need to update the `inventory` file with the IP addresses of the instances. Run this command from the `ad/aws-sevenkingdoms.local/terraform` directory:

```bash
cp ../inventory.template ../inventory && terraform output | awk -F ' = ' '{gsub(/"/, "", $2); print $1" "$2}' | while read -r key ip; do sed -i.bak "s/\($key ansible_host=\)[^ ]*/\1$ip/" ../inventory; done && mv ../inventory.bak ../inventory
```

2. Also, update the following line with your password (you can retrieve it in `ad/aws-sevenkingdoms.local/terraform/scripts/ansibleuserdata.ps1`):

```
ansible_password=YourSecretPassword
```

#### Deployment

Install the Ansible dependencies:

```bash
ansible-galaxy install -r requirements.yml
```

Update the SG to add tcp/5985 (WinRM-HTTP) and tcp/5986 (WinRM-HTTPS) to your IP.

Test the connection to the Windows instances:

```bash
$ ansible -i ../ad/aws-sevenkingdoms.local/inventory all -m win_ping
```

Then, in the `ansible` directory execute the playbooks one by one (it is important to respect the order):

```bash
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory build.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-servers.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-parent_domain.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-child_domain.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-members.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-trusts.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-data.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-gmsa.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory laps.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-relations.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory adcs.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory ad-acl.yml
# Don't know exactly why but you need to run servers role for each server, it
# increases your chances to have a successful deployment:
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory --limit srv02 servers.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory --limit srv03 servers.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory security.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory vulnerabilities.yml
$ ansible-playbook -i ../ad/aws-sevenkingdoms.local/inventory reboot.yml
```

> If you have an error on one playbook, you can try to run it again. It seems to solve quite a lot of issues.

## Troubleshootings

### RDP connection

If you need to connect to the Windows instances, you need:

- to update the security group of the instances to allow RDP connections from your IP address,
- start your RDP client and use the `ansible` user and the password you generated earlier.

### Error on playbook

```
objc[6387]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
objc[6387]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called. We cannot safely call it or ignore it in the fork() child process. Crashing instead. Set a breakpoint on objc_initializeAfterForkError to debug.
```

Just add `env no_proxy='*'` at the begining of each command or `export no_proxy='*'` for your shell session.
