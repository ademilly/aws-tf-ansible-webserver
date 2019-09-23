# AWS webserver with Terraform and Ansible

## todo
- add ansible example

## quick start

- setup terraform => https://www.terraform.io/
- setup ansible   => https://www.ansible.com/ (not used now)

```bash
    $ git clone git@github.com:ademilly/aws-tf-ansible-webserver.git webserver && cd webserver/
    $ terraform init
    $ ssh-keygen -t rsa -b 4096 -C 'aws-deploy-webserver' -N '' -f aws-deploy-webserver
    $ terraform plan -var 'cidr=["IPV4/32"]'
    $ terraform apply
    $ ssh -i aws-deploy-webserver ubuntu@`head -n 2 hosts | tail -n 1`
```

## variables
- [cidr](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) => list of IP range allowed to ping port 22 
