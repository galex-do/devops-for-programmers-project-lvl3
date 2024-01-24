### Hexlet tests and linter status:
[![Actions Status](https://github.com/galex-do/devops-for-programmers-project-lvl3/workflows/hexlet-check/badge.svg)](https://github.com/galex-do/devops-for-programmers-project-lvl3/actions)

### Hexlet 3: Deploy in cloud and configuration

#### Specifics

This project is supposed to use on specific YandexCloud account, with specific credentials. Credentials and secrets are stored in terraform/secrets, encrypted with gpg key.

To successfully operate with project on your machine, you need to:

- Import private part of [GPG key](https://ioflood.com/blog/install-gpg-command-linux/) with fingerprint from terraform/Makefile. Lay received key to file `key.gpg` in root of project and execute `make import-key`. Store it ONLY locally or in some well protected passwords storage.
- Install [terraform cli](https://developer.hashicorp.com/terraform/install)
- Install [sops editor](https://github.com/getsops/sops/tree/0494bc41911bc6e050ddd8a5da2bbb071a79a5b7#up-and-running-in-60-seconds) (neccessary to work with secrets)
- Install [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)

When you get all tools, execute in project:

```
make prepare-project
```

This will decrypt backend configuration for terraform work and install needed ansible roles and collections.

---

#### Registrar

We buy domain name on any registrar, for example https://reg.ru and set for this domain name custom nameservers - in project we use YandexCloud for infrastucture, so it will be cloud NS ns1.yandexcloud.net and ns2.yandexcloud.net. 

#### Terraform

We use terraform here to spawn in YandexCloud:

- Yandex VPC regional network and zonal subnet to bind resources with
- 2 linux virtual machines *packed with docker*
- Postgresql MDB cluster which used as db for stateless applications on both machines
- Public DNS zone in Cloud DNS and domain-level ssl certificate in Certificate Manager
- L7 Application load balancer, binding white public IP with app backend on instances. ALB receives traffic on 80 and 443. 80 redirects to 443. 443 routes to application.
- DNS A-record to bind service domain name with current ALB public IP. If infrastructure's up, app can be accessed on https://app.oo-woo.ru

Also, terraform:

- connects to Datadog cloud API and creates there monitor based on metrics, collected with datadog agent (which will be installed later on hosts with ansible).
- generates ssh-config and variable file, which will be used by ansible on configuration step.

To set up terraform infrastructure, execute

```
make setup-infra
```

You will possibly need to re-apply terraform deployment after validating new-created ssl certificate with letsencrypt (ALB can't be created before that). Use for this:

```
make update-infra
```

---

#### Ansible

After deployment terraform provides to ansible:

- secrets to connect to DB from application
- secrets to connect datadog agents to correct monitoring cloud
- ssh-config parametrizing ansible ssh connections to working nodes

When infrastructure is up, execute:

```
make configure-infra
```

This will setup pip on hosts (to interact with docker API over ansible), deploy datadog agents and connect them to cloud API, and deploy application with parameters described in ansible/group_vars

---

#### What you need for fork?

If you want to use project for your own purpose (unrelated with mine), you can possibly fork this repo and modify some deployment parameters.

**Backend**: Terraform in project uses for deployment *cloud service account* and *s3 backend with YDB for state locks*. You can modify `terraform/backend.tf` and `terraform/providers.tf` the way you need if you prefer other solution. But don't forget that secrets must be hidden or stored encrypted.

**tfvars**: You can modify tf.auto.tfvars to scale database resources, change version or change VMs. You can also add more instances to list, and they all by default will be added to balancing and ssh-config, but note that after that you also must add new hosts to ansible/inventory.ini to configure them.

**secrets**: Replace secret.enc.json to your own (and other secrets if needed), encrypted with your own key. Create simple json `secret.decrypted` file containing fields with clouds & db credentials:

```
{
	"entry_user": "linuxuser",
	"entry_key": "./.../id_rsa.pub",
	"cloud_id": "ab...xnm",
	"folder_id": "mc...h07",
	"service_account": {
		"access_key": "vxb...bsg",
		"secret_key": "abc........sfn"
	},
	"db_user": "user",
	"db_name": "db",
	"db_password": "password",
	"datadog_api_key": "nsgs...ngsgs",
	"datadog_app_key": "bf2...f0r",
	"datadog_api_url": "https://api.us4.datadoghq.com"
}
```

export your GPG fingerprint and use sops to encrypt your file

```
export GPG_KEY=GBS...NG178
sops --encrypt --pgp ${GPG_KEY} secret.decrypted > terraform/secrets/secret.enc.json
```

Now your secret file is ready to use with infrastructure. To modify it later use sops editor like:

```
sops terraform/secrets/secret.enc.json
```

Also, replace GPG fingerprint in terraform/Makefile to use make commands with your secrets.
