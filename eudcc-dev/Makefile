SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SUB_ID = $(shell cat $(ROOT_DIR)/../terraform.tfvars| grep ^subscription_id | cut -d'"' -f2)

.PHONY: all
all: terraform ssh-config

.PHONY: terraform
terraform:
	terraform init
	terraform apply -auto-approve -var-file $(ROOT_DIR)/../terraform.tfvars
	terraform output -json > $(ROOT_DIR)/jumpbox-ssh-configs/output.json

.PHONY: terraform-destroy
terraform-destroy:
	terraform destroy -var-file $(ROOT_DIR)/../terraform.tfvars

.PHONY: ssh-config
ssh-config: regen-tf-output ssh-config-write

.PHONY: regen-tf-output
regen-tf-output:
	terraform output -json > $(ROOT_DIR)/jumpbox-ssh-configs/output.json

.PHONY: ssh-config-write
ssh-config-write: IE_RG = $(shell cat $(ROOT_DIR)/jumpbox-ssh-configs/output.json | jq '.["ie_rg_name"]["value"]')
ssh-config-write: EU_RG = $(shell cat $(ROOT_DIR)/jumpbox-ssh-configs/output.json | jq '.["eu_rg_name"]["value"]')
ssh-config-write:
	rm $(ROOT_DIR)/jumpbox-ssh-configs/*-ssh-config || true
	az ssh config --subscription $(SUB_ID) -g $(IE_RG) -n $(IE_RG)-jumpbox-vm -f $(ROOT_DIR)/jumpbox-ssh-configs/ie-ssh-config
	chmod 0600 $$(cat $(ROOT_DIR)/jumpbox-ssh-configs/ie-ssh-config | grep IdentityFile | cut -d" " -f2 | head -n1)
	az ssh config --subscription $(SUB_ID) -g $(EU_RG) -n $(EU_RG)-jumpbox-vm -f $(ROOT_DIR)/jumpbox-ssh-configs/eu-ssh-config
	chmod 0600 $$(cat $(ROOT_DIR)/jumpbox-ssh-configs/eu-ssh-config | grep IdentityFile | cut -d" " -f2 | head -n1)
