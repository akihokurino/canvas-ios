MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

vendor:
	yarn install
	
gen:
	npx apollo client:codegen ./Canvas/Infra/CanvasServer/API.swift --target=swift --queries=./Canvas/Infra/CanvasServer/canvas.app.graphql --localSchemaFile=./Canvas/Infra/CanvasServer/canvas.schema.graphql --namespace=CanvasAPI
	npx apollo client:codegen ./Canvas/Infra/NftServer/API.swift --target=swift --queries=./Canvas/Infra/NftServer/nft.app.graphql --localSchemaFile=./Canvas/Infra/NftServer/nft.schema.graphql --namespace=NftAPI
