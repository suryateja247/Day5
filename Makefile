SHELL := /bin/bash

.PHONY: check-tools bootstrap shared-services env-dev env-qa env-stage env-prod sample-build

check-tools:
	./scripts/check-tools.sh

bootstrap:
	./scripts/terraform-run.sh terraform/bootstrap apply

shared-services:
	./scripts/terraform-run.sh terraform/shared-services apply

env-dev:
	./scripts/terraform-run.sh terraform/environments/dev apply

env-qa:
	./scripts/terraform-run.sh terraform/environments/qa apply

env-stage:
	./scripts/terraform-run.sh terraform/environments/stage apply

env-prod:
	./scripts/terraform-run.sh terraform/environments/prod apply

sample-build:
	cd examples/sample-app && docker build -t sample-app:local .
