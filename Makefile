SHELL := /bin/bash

MAKEFLAGS := --silent --no-print-directory

.PHONY: help

.DEFAULT_GOAL := help

help:
	@echo "Please use 'make <target>' where <target> is one of"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z\._-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

pandocImage := survivorbat/pandoc-eisvogel:latest
terraformImage := survivorbat/terraform-scratch:0.12.24
ansibleImage := survivorbat/ansible:v0.4

gen-docs: ## Build the documentation to a pdf
	docker run --rm -e OUTPUT_PATH=./documentation.pdf -v $(CURDIR)/docs:/data ${pandocImage} --listings

fmt: ## Format terraform code
	docker run --rm -v $(CURDIR)/terraform:/app ${terraformImage} fmt

validate: ## Validate terraform code
	docker run --rm -v $(CURDIR)/terraform:/app ${terraformImage} validate

init: ## Initialize terraform
	docker run --rm -v $(CURDIR)/terraform:/app ${terraformImage} init

ansible.lint: ## Run ansible lint
	docker run --rm -v $(CURDIR)/terraform/ansible:/app survivorbat/ansible:v0.4 ansible-lint /app/site.yml
