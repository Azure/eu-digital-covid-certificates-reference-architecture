SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: all
all: bootstrap build-terraform build-hugo

.PHONY: bootstrap
bootstrap:
	npm install
	git submodule update --init --recursive --depth 1

.PHONY: build-terraform
build-terraform:
	terraform-docs tfvars hcl ../eudcc-dev --description --output-file ../docs/content/en/terraform/variables.md --output-template "<!-- BEGIN_TF_DOCS_DEV -->\n\`\`\`ini\n{{ .Content }}\n\`\`\`\n<!-- END_TF_DOCS_DEV -->"
	terraform-docs tfvars hcl ../eudcc-ie  --description --output-file ../docs/content/en/terraform/variables.md --output-template "<!-- BEGIN_TF_DOCS_IE -->\n\`\`\`ini\n{{ .Content }}\n\`\`\`\n<!-- END_TF_DOCS_IE -->"
	terraform-docs tfvars hcl ../eudcc-eu  --description --output-file ../docs/content/en/terraform/variables.md --output-template "<!-- BEGIN_TF_DOCS_EU -->\n\`\`\`ini\n{{ .Content }}\n\`\`\`\n<!-- END_TF_DOCS_EU -->"
	terraform-docs markdown ../terraform-modules/base-infrastructure --sensitive --output-file ../../docs/content/en/terraform/modules/base-infra.md --output-mode inject --sort-by required
	terraform-docs markdown ../terraform-modules/dev-jumpbox --sensitive --output-file ../../docs/content/en/terraform/modules/jumpbox.md --output-mode inject --sort-by required
	terraform-docs markdown ../eudcc-dev --sensitive --output-file ../docs/content/en/terraform/dev.md --output-mode inject --sort-by required
	terraform-docs markdown ../eudcc-eu --sensitive --output-file ../docs/content/en/terraform/eu.md --output-mode inject --sort-by required
	terraform-docs markdown ../eudcc-ie --sensitive --output-file ../docs/content/en/terraform/ie.md --output-mode inject --sort-by required

.PHONY: build-hugo
build-hugo: bootstrap
	hugo -v --debug --enableGitInfo

.PHONY: server
server: all
	hugo server --bind 0.0.0.0
