MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

COGNITO_EMAIL := ""
COGNITO_PASSWORD := ""

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

cognito-set-password:
	aws cognito-idp admin-set-user-password \
        --user-pool-id ap-northeast-1_omBvnPYzl \
        --username ${COGNITO_EMAIL} \
        --password ${COGNITO_PASSWORD} \
				--permanent \
				--profile me

cognito-token:
	aws cognito-idp admin-initiate-auth \
        --user-pool-id ap-northeast-1_omBvnPYzl \
        --client-id ehd60ftsekljsqu683f2j6i0e \
        --auth-flow ADMIN_NO_SRP_AUTH \
        --auth-parameters USERNAME=${COGNITO_EMAIL},PASSWORD=${COGNITO_PASSWORD} \
				--profile me