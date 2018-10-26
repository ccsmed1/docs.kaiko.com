MIDDLEMAN     = bundle exec middleman
USER_ID       = $(shell id -u)
DOCKERCOMPOSE = docker-compose run -e USER_ID=$(USER_ID) --service-ports --rm app

.PHONY: build
build: ## build the documentation
	@$(DOCKERCOMPOSE) $(MIDDLEMAN) build

.PHONY: server
server: ## run a localhost server to expose documentation
	@$(DOCKERCOMPOSE) $(MIDDLEMAN) server

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
