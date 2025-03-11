WEBSITE_REPOSITORY=github.com/energimidt/terraform-azurerm-apimanagement

default: init


tools:
	@echo "==> installing required tooling..."
	go install github.com/terraform-docs/terraform-docs@v0.16.0

documentation:
	terraform-docs markdown "$(CURDIR)" --output-file README.md

graph:
	@sh -c "'$(CURDIR)/scripts/terraform-graph.sh'"

clean:
	rm --recursive .terraform

init:
	terraform init -upgrade \
	&& terraform init -reconfigure -upgrade

fmt: init
	terraform fmt -recursive . \
	&& terraform fmt -check

validate: fmt
	terraform validate .


.PHONY: \
	build \
	documentation \
	fmt\
	graph \
	init \
	tools \
	validate
