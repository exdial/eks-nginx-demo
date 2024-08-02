.SILENT: # do not echo commands as we run them
.DEFAULT_GOAL := help

plan: ## run terraform plan
	terragrunt run-all plan

apply: ## run terraform apply
	terragrunt run-all apply

destroy: ## run terraform destroy
	terragrunt run-all destroy

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
