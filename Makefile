SHELL := /bin/sh

.PHONY: help issue-sync db-up db-down qdrant-up qdrant-down migrate seed verify test typecheck

help:
	@printf '%s\n' \
		'Founder Decision OS Make targets' \
		'' \
		'issue-sync     Run GitHub issue setup script in dry-run mode' \
		'db-up          Start PostgreSQL from docker-compose.yml when available' \
		'db-down        Stop PostgreSQL and remove local volumes when available' \
		'qdrant-up      Start Qdrant from docker-compose.qdrant.yml when available' \
		'qdrant-down    Stop Qdrant and remove local volumes when available' \
		'migrate        Run scripts/migrate.sh when available' \
		'seed           Run scripts/seed.sh when available' \
		'verify         Run scripts/verify.sh when available' \
		'test           Run smoke-test.sh when available, otherwise typecheck when available' \
		'typecheck      Run npm typecheck when package.json and tsconfig.json are available'

issue-sync:
	@if [ -z "$(REPO)" ]; then \
		echo 'REPO is required. Example: make issue-sync REPO=OWNER/REPO'; \
		exit 1; \
	fi
	@python3 scripts/github/create_founder_decision_os_issues.py --repo "$(REPO)"

db-up:
	@if [ ! -f docker-compose.yml ]; then \
		echo 'docker-compose.yml is not present on this branch.'; \
		exit 1; \
	fi
	@docker compose -f docker-compose.yml up -d postgres

db-down:
	@if [ ! -f docker-compose.yml ]; then \
		echo 'docker-compose.yml is not present on this branch.'; \
		exit 1; \
	fi
	@docker compose -f docker-compose.yml down -v

qdrant-up:
	@if [ ! -f docker-compose.qdrant.yml ]; then \
		echo 'docker-compose.qdrant.yml is not present on this branch.'; \
		exit 1; \
	fi
	@docker compose -f docker-compose.qdrant.yml up -d qdrant

qdrant-down:
	@if [ ! -f docker-compose.qdrant.yml ]; then \
		echo 'docker-compose.qdrant.yml is not present on this branch.'; \
		exit 1; \
	fi
	@docker compose -f docker-compose.qdrant.yml down -v

migrate:
	@if [ ! -x scripts/migrate.sh ] && [ ! -f scripts/migrate.sh ]; then \
		echo 'scripts/migrate.sh is not present on this branch.'; \
		exit 1; \
	fi
	@sh scripts/migrate.sh

seed:
	@if [ ! -x scripts/seed.sh ] && [ ! -f scripts/seed.sh ]; then \
		echo 'scripts/seed.sh is not present on this branch.'; \
		exit 1; \
	fi
	@sh scripts/seed.sh

verify:
	@if [ ! -x scripts/verify.sh ] && [ ! -f scripts/verify.sh ]; then \
		echo 'scripts/verify.sh is not present on this branch.'; \
		exit 1; \
	fi
	@sh scripts/verify.sh

test:
	@if [ -f scripts/smoke-test.sh ]; then \
		sh scripts/smoke-test.sh; \
	elif [ -f package.json ] && [ -f tsconfig.json ]; then \
		npm run typecheck; \
	else \
		echo 'No test or typecheck entrypoint is available on this branch.'; \
		exit 1; \
	fi

typecheck:
	@if [ ! -f package.json ] || [ ! -f tsconfig.json ]; then \
		echo 'package.json and tsconfig.json are required for typecheck.'; \
		exit 1; \
	fi
	@npm run typecheck
