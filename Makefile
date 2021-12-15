SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PREFIX = $(shell cat $(ROOT_DIR)/terraform.tfvars| grep ^prefix | cut -d'"' -f2)
VERSION=$(shell git describe --long --tags)

define COMPLETION_TEXT_BODY
Congratulations!

APECOE's Privacy focused Blueprint of the EU Digital Green Certificate, (Version: "$(VERSION)") has been successfully deployed!

Please refer to the documentation, to issue and verify your signed test certificates. https://azure.github.io/eu-digital-covid-certificates-reference-architecture/ .

You can SSH into the regions Jumpbox to view the Kubernetes Cluster, Databases and key vaults secrets and perform operations, by the following commands:
EU jumpbox:
$(shell [ -f "$(ROOT_DIR)/eudcc-dev/jumpbox-ssh-configs/output.json" ] && $(MAKE) -sC eudcc-eu print-ssh-cmd)

IE jumpbox:
$(shell [ -f "$(ROOT_DIR)/eudcc-dev/jumpbox-ssh-configs/output.json" ] &&  $(MAKE) -sC eudcc-ie print-ssh-cmd)


To issue your first test Cert, in you Web Browser head to: $(shell [ -f "$(ROOT_DIR)/eudcc-ie/output.json" ] && $(MAKE) -sC eudcc-ie output-issuance-web-address)

Required Endpoints to apply when building the Android Apps:
- Issuance Service: $(shell [ -f "$(ROOT_DIR)/eudcc-ie/output.json" ] && $(MAKE) -sC eudcc-ie output-issuance-service-url)
- Business Rule Service: $(shell [ -f "$(ROOT_DIR)/eudcc-ie/output.json" ] && $(MAKE) -sC eudcc-ie output-businessrule-service-url)
- Verifier Service: $(shell [ -f "$(ROOT_DIR)/eudcc-ie/output.json" ] && $(MAKE) -sC eudcc-ie output-verifier-service-url)

Enjoy! 😀


endef
export COMPLETION_TEXT_BODY


.PHONY: all
all: checks certs terraform

.PHONY: checks
checks:
	@echo "Verifying terraform.tfvars file exists"
	@test -f terraform.tfvars || { echo "FAIL: Please create and populate the terraform.tfvars file before proceeding"; exit 1; }

	@echo "Ensure az CLI has access to the specified subscription"
	@az account show -s $$(cat terraform.tfvars| grep ^subscription_id | cut -d'"' -f2) &>/dev/null || { echo "FAIL: Please run \`az login\` before proceeding"; exit 1; }

.PHONY: certs
certs:
	$(ROOT_DIR)/scripts/generate-certs.sh

.PHONY: dev
dev: checks
	$(MAKE) -C eudcc-dev terraform
	$(MAKE) -C eudcc-dev ssh-config

.PHONY: eu
eu: checks
	$(MAKE) -C eudcc-eu all

.PHONY: ie
ie: checks
	$(MAKE) -C eudcc-ie all

.PHONY: terraform
terraform: dev eu ie print-completion-msg

.PHONY: terraform-destroy
terraform-destroy: checks
	$(MAKE) -C eudcc-ie terraform-destroy
	$(MAKE) -C eudcc-eu terraform-destroy
	$(MAKE) -C eudcc-dev terraform-destroy

.PHONY: start-all-tunnels
start-all-tunnels: checks
	$(MAKE) -C eudcc-eu ssh-tunnel-start
	$(MAKE) -C eudcc-ie ssh-tunnel-start

.PHONY: stop-all-tunnels
stop-all-tunnels:
	$(MAKE) -C eudcc-eu ssh-tunnel-stop
	$(MAKE) -C eudcc-ie ssh-tunnel-stop

.PHONY: android-build
android-build:
	$(MAKE) -C upstream all

.PHONY: print-ssh-cmd
print-ssh-cmd:
	@$(MAKE) -C eudcc-eu print-ssh-cmd
	@$(MAKE) -C eudcc-ie print-ssh-cmd

.PHONY: print-hostnames
print-hostnames:
	@$(MAKE) -C eudcc-eu output-hostnames
	@$(MAKE) -C eudcc-ie output-hostnames

.PHONY: print-completion-msg
print-completion-msg:
	@echo "$$COMPLETION_TEXT_BODY"

.PHONY: state-export
state-export:
	@mkdir -p exports
	@mkdir -p exports/eudcc-dev
	@mkdir -p exports/eudcc-eu
	@mkdir -p exports/eudcc-ie
	@[[ -d certs ]] && rsync -avhW --no-compress --progress certs/ exports/certs/
	@[[ -f eudcc-dev/terraform.tfstate ]] && rsync -avhW --no-compress --progress eudcc-dev/terraform.tfstate exports/eudcc-dev/terraform.tfstate
	@[[ -f eudcc-eu/terraform.tfstate ]] && rsync -avhW --no-compress --progress eudcc-eu/terraform.tfstate exports/eudcc-eu/terraform.tfstate
	@[[ -f eudcc-ie/terraform.tfstate ]] && rsync -avhW --no-compress --progress eudcc-ie/terraform.tfstate exports/eudcc-ie/terraform.tfstate
	@[[ -f terraform.tfvars ]] && rsync -avhW --no-compress --progress terraform.tfvars exports/terraform.tfvars
	@zip -r exports.zip exports/
	@rm -rf exports/
	@echo "Export Complete!"

.PHONY: state-import
state-import:
	@unzip import.zip
	@[[ -d import/certs ]] && rsync -avhW --no-compress --progress import/certs/ certs/
	@[[ -f import/eudcc-dev/terraform.tfstate ]] && rsync -avhW --no-compress --progress import/eudcc-dev/terraform.tfstate eudcc-dev/terraform.tfstate
	@[[ -f import/eudcc-eu/terraform.tfstate ]] && rsync -avhW --no-compress --progress import/eudcc-eu/terraform.tfstate eudcc-eu/terraform.tfstate
	@[[ -f import/eudcc-ie/terraform.tfstate ]] && rsync -avhW --no-compress --progress import/eudcc-ie/terraform.tfstate eudcc-ie/terraform.tfstate
	@[[ -f import/terraform.tfvars ]] && rsync -avhW --no-compress --progress import/terraform.tfvars terraform.tfvars
	@rm -rf import/
	@echo "Import Complete!"
