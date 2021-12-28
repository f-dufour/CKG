# Makefile
# Manage CKG with docker micro-services
# October 2021

COMPOSE := docker compose

build: ## Build all CKG services
	$(COMPOSE) build
up:    ## Launch all CKG services
	$(COMPOSE) up
down:  ## Stop all CKG services
	$(COMPOSE) down
help:  ## Print this help
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
