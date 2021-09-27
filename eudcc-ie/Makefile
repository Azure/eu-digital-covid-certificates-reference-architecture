SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SUB_ID = $(shell cat $(ROOT_DIR)/../terraform.tfvars| grep ^subscription_id | cut -d'"' -f2)

JUMP_BOX_IDENTITY_FILE = $(shell cat $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/ie-ssh-config | grep IdentityFile | cut -d' ' -f2 | head -n 1)
JUMP_BOX_USER = $(shell cat $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/ie-ssh-config | grep User | cut -d' ' -f2 | head -n 1)
JUMP_BOX_HOST = $(shell cat $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/ie-ssh-config | grep HostName | cut -d' ' -f2 | head -n 1)

.PHONY: all
all: ssh-tunnel-start terraform ssh-tunnel-stop

.PHONY: ssh-tunnel-start
ssh-tunnel-start: IE_RG = $(shell cat $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/output.json | jq '.["ie_rg_name"]["value"]')
ssh-tunnel-start:
	ssh -F $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/ie-ssh-config -N $(IE_RG)-$(IE_RG)-jumpbox-vm -D 0.0.0.0:8882 -oStrictHostKeyChecking=no & echo "$$!" > $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/ie.pid

.PHONY: ssh-tunnel-stop
ssh-tunnel-stop: PID = $(shell cat $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/ie.pid)
ssh-tunnel-stop:
	kill -9 $(PID) || true
	rm $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/ie.pid

.PHONY: print-ssh-cmd
print-ssh-cmd:IE_RG = $(shell cat $(ROOT_DIR)/../eudcc-dev/jumpbox-ssh-configs/output.json | jq '.["ie_rg_name"]["value"]')
print-ssh-cmd:
	@echo "az ssh vm --subscription $(SUB_ID) -g $(IE_RG) -n $(IE_RG)-jumpbox-vm"

.PHONY: workspace
workspace:
	terraform init
	terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

.PHONY: terraform
terraform:
	find $(ROOT_DIR)/../charts/ -name \*.tgz -delete -or -name Chart.lock -delete
	terraform init
	ALL_PROXY=socks5h://127.0.0.1:8882 HTTPS_PROXY=socks5://127.0.0.1:8882 HTTP_PROXY=socks5://127.0.0.1:8882 terraform apply -auto-approve -var-file $(ROOT_DIR)/../terraform.tfvars -var jump_box_identity_file=$(JUMP_BOX_IDENTITY_FILE) -var jump_box_identity_user=$(JUMP_BOX_USER) -var jump_box_identity_host=$(JUMP_BOX_HOST)
	terraform output -json > $(ROOT_DIR)/output.json

.PHONY: terraform-destroy
terraform-destroy:
	ALL_PROXY=socks5h://127.0.0.1:8882 HTTPS_PROXY=socks5://127.0.0.1:8882 HTTP_PROXY=socks5://127.0.0.1:8882 terraform destroy -var-file $(ROOT_DIR)/../terraform.tfvars -var jump_box_identity_file=$(JUMP_BOX_IDENTITY_FILE) -var jump_box_identity_user=$(JUMP_BOX_USER) -var jump_box_identity_host=$(JUMP_BOX_HOST)

.PHONY: output-hostnames
output-hostnames:
	@echo "$(shell cat $(ROOT_DIR)/output.json | jq '.[]["value"]' | sed "s/.*/&\//")"

.PHONY: output-issuance-web-address
output-issuance-web-address:
	@echo "$(shell cat $(ROOT_DIR)/output.json | jq '.["issuance_web_address"]["value"]' | sed "s/.*/&\//")"

.PHONY: output-issuance-service-url
output-issuance-service-url:
	@echo "$(shell cat $(ROOT_DIR)/output.json | jq '.["issuance_service_url"]["value"]' | sed "s/.*/&\//")"

.PHONY: output-businessrule-service-url
output-businessrule-service-url:
	@echo "$(shell cat $(ROOT_DIR)/output.json | jq '.["businessrule_service_url"]["value"]' | sed "s/.*/&\//")"

.PHONY: output-verifier-service-url
output-verifier-service-url:
	@echo "$(shell cat $(ROOT_DIR)/output.json | jq '.["verifier_service_url"]["value"]' | sed "s/.*/&\//")"
