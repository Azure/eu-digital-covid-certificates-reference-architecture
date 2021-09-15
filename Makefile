SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PREFIX = $(shell cat $(ROOT_DIR)/terraform.tfvars| grep ^prefix | cut -d'"' -f2)
VERSION=$(shell git describe --long --tags)

define COMPLETION_TEXT_BODY
Congratulations!

APE-COE's Privacy focused Blueprint of the EU Digital Green Certificate, (Version: "$(VERSION)") has been successfully deployed!

Please refer to the documentation, to issue and verify your signed test certificates. https://azure.github.io/eu-digital-covid-certificates-reference-architecture/ .

You can SSH into the regions Jumpbox to view the Kubernetes Cluster, Databases and key vaults secrets and perform operations, by the following commands:
EU jumpbox:
$(shell $(MAKE) -sC eudgc-eu print-ssh-cmd)

IE jumpbox:
$(shell $(MAKE) -sC eudgc-ie print-ssh-cmd)


To issue your first test Cert, in you Web Browser head to: $(shell $(MAKE) -sC eudgc-ie output-hostnames)


Enjoy! 😀


endef
export COMPLETION_TEXT_BODY


ifeq ($(strip $(PREFIX)),)
	WORKSPACE = "default"
else
	WORKSPACE = $(PREFIX)
endif

.PHONY: all
all: checks certs workspace dev eu ie print-completion-msg

.PHONY: checks
checks:
	test -f terraform.tfvars

.PHONY: certs
certs:
	$(ROOT_DIR)/scripts/generate-certs.sh

.PHONY: workspace
workspace: checks
	WORKSPACE=$(WORKSPACE) $(MAKE) -C eudgc-dev workspace
	WORKSPACE=$(WORKSPACE) $(MAKE) -C eudgc-eu workspace
	WORKSPACE=$(WORKSPACE) $(MAKE) -C eudgc-ie workspace

.PHONY: dev
dev:
	$(MAKE) -C eudgc-dev terraform
	$(MAKE) -C eudgc-dev ssh-config

.PHONY: eu
eu:
	$(MAKE) -C eudgc-eu all

.PHONY: ie
ie:
	$(MAKE) -C eudgc-ie all

.PHONY: terraform-destroy
terraform-destroy:
	$(MAKE) -C eudgc-ie terraform-destroy
	$(MAKE) -C eudgc-eu terraform-destroy
	$(MAKE) -C eudgc-dev terraform-destroy

.PHONY: start-all-tunnels
start-all-tunnels:
	$(MAKE) -C eudgc-eu ssh-tunnel-start
	$(MAKE) -C eudgc-ie ssh-tunnel-start

.PHONY: stop-all-tunnels
stop-all-tunnels:
	$(MAKE) -C eudgc-eu ssh-tunnel-stop
	$(MAKE) -C eudgc-ie ssh-tunnel-stop

.PHONY: print-ssh-cmd
print-ssh-cmd:
	@$(MAKE) -C eudgc-eu print-ssh-cmd
	@$(MAKE) -C eudgc-ie print-ssh-cmd

.PHONY: print-hostnames
print-hostnames:
	@$(MAKE) -C eudgc-eu output-hostnames
	@$(MAKE) -C eudgc-ie output-hostnames

.PHONY: print-completion-msg
print-completion-msg:
	@echo "$$COMPLETION_TEXT_BODY"
