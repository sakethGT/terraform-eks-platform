.PHONY: help init plan apply destroy fmt validate lint docs clean

STACK ?= dev-npe
STACK_DIR := stacks/$(STACK)

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialize Terraform for a stack (STACK=dev-npe)
	cd $(STACK_DIR) && terraform init

plan: ## Plan Terraform changes for a stack (STACK=dev-npe)
	cd $(STACK_DIR) && terraform plan

apply: ## Apply Terraform changes for a stack (STACK=dev-npe)
	cd $(STACK_DIR) && terraform apply

destroy: ## Destroy Terraform resources for a stack (STACK=dev-npe)
	cd $(STACK_DIR) && terraform destroy

fmt: ## Format all Terraform files
	terraform fmt -recursive

validate: ## Validate Terraform configuration for a stack (STACK=dev-npe)
	cd $(STACK_DIR) && terraform validate

lint: ## Run tflint on a stack (STACK=dev-npe)
	cd $(STACK_DIR) && tflint

docs: ## Generate terraform-docs for modules
	terraform-docs markdown table modules/aws_eks > modules/aws_eks/README.md

clean: ## Remove .terraform directories
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -name "*.tfplan" -delete

plan-all: ## Plan all stacks
	@for dir in stacks/*/; do \
		echo "Planning $$dir..."; \
		(cd $$dir && terraform plan); \
	done

fmt-check: ## Check formatting without making changes
	terraform fmt -recursive -check

security-scan: ## Run checkov security scan
	checkov -d $(STACK_DIR)
