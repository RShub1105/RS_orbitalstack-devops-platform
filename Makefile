TF_DIR=terraform

.PHONY: bootstrap init plan apply destroy lint verify

bootstrap:
	cd $(TF_DIR)/bootstrap && terraform init && terraform apply

init:
	cd $(TF_DIR) && terraform init

plan:
	cd $(TF_DIR) && terraform plan

apply:
	cd $(TF_DIR) && terraform apply

destroy:
	cd $(TF_DIR) && terraform destroy

lint:
	helm lint helm/charts/*
	terraform -chdir=$(TF_DIR) fmt -check -recursive
	terraform -chdir=$(TF_DIR) validate

verify:
	./scripts/verify-deployment.sh

