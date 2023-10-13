# GOAD on AWS

This is based on the works of [jarrault](https://github.com/jarrault/GOAD/tree/azure/ad/azure-sevenkingdoms.local) and [0xBallPoint](https://github.com/0xBallpoint/LOAD).

## Pre-requisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

## Setup

### AWS CLI

You will need to configure your AWS CLI with your credentials. You can do this by running `aws configure` and entering your credentials.

### Create SSH Key

```bash
$ cd ad/aws-sevenkingdoms.local
$ ssh-keygen -t rsa -N "" -b 2048 -C "TerraformKey" -f ./terraform/keys/TerraformKey
```

### Terraform

To initialize terraform, run the following command:

```bash
$ cd ad/aws-sevenkingdoms.local/terraform
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

Think to change the chmod on the key file:

```bash
$ chmod 400 ./terraform/keys/TerraformKey
```

### Ansible

In the `ansible` directory:

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
