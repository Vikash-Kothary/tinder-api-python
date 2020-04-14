#/bin/make

TINDER_NAME ?= "$(shell python3 setup.py --name)"
TINDER_VERSION ?= "$(shell python3 setup.py --version)"
TINDER_DESCRIPTION ?= "$(shell python3 setup.py --description)"

-include .env
export

.DEFAULT_GOAL := help
.PHONY: help #: Display all commands.
help:
	@awk 'BEGIN {FS = " ?#?: "; print ""${TINDER_NAME}" "${TINDER_VERSION}"\n"${TINDER_DESCRIPTION}"\n\nUsage: make \033[36m<command>\033[0m\n\nCommands:"} /^.PHONY: ?[a-zA-Z_-]/ { printf "  \033[36m%-10s\033[0m %s\n", $$2, $$3 }' $(MAKEFILE_LIST)

.PHONY: init #: Download dependencies.
init:
	@if [[ ! -d .venv ]]; then \
		python3 -m venv .venv && \
		source .venv/bin/activate && \
		pip3 install --upgrade pip && \
		pip3 install -r requirements.txt; \
	fi

.PHONY: examples
examples:
	@.venv/bin/jupyter notebook --notebook-dir=./examples

.PHONY: tests
tests:
	@.venv/bin/python3 -m pytest --doctest-modules

.PHONY: clean
clean:
	@find . -type d -name '__pycache__' -exec rm --force --recursive {} +
	@find . -name '*.pyc' -exec rm --force {} +
	@find . -name '*.pyo' -exec rm --force {} +
	@name '*~' -exec rm --force  {}
	@rm --force --recursive build/
	@rm --force --recursive dist/
	@rm --force --recursive *.egg-info

.PHONY: build
build:
	@python3 setup.py build