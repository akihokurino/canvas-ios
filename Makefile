MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

vendor:
	yarn install
	
gen:
	npx apollo client:codegen ./Canvas/Infra/AssetGenerator/AssetGeneratorAPI.swift \
		--target=swift --queries=./Canvas/Infra/AssetGenerator/asset-generator.app.graphql \
		--localSchemaFile=./Canvas/Infra/AssetGenerator/asset-generator.schema.graphql \
		--namespace=AssetGeneratorAPI
	npx apollo client:codegen ./Canvas/Infra/NftGenerator/NftGeneratorAPI.swift \
		--target=swift --queries=./Canvas/Infra/NftGenerator/nft-generator.app.graphql \
		--localSchemaFile=./Canvas/Infra/NftGenerator/nft-generator.schema.graphql \
		--namespace=NftGeneratorAPI