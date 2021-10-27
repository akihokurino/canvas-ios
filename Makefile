MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

vendor:
	yarn install
	
gen:
	npx apollo client:codegen ./Canvas/Infra/GraphQL/API.swift --target=swift --queries=./Canvas/Infra/GraphQL/app.graphql --localSchemaFile=./Canvas/Infra/GraphQL/schema.graphql --namespace=GraphQL
