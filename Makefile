.PHONY: help setup server open test lint

help: ## Show this help
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup: ## Install project dependencies
	bundle install

server: ## Start the Rails server
	bundle exec rails server

open: ## Open the application in the default browser
	start http://localhost:3000/

test: ## Run the test suite
	bundle exec rspec

lint: ## Run Rubocop linting
	bundle exec rubocop

