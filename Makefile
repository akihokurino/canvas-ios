MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

COGNITO_EMAIL := ""
COGNITO_PASSWORD := ""

vendor:
	yarn install
	
gen:
	npx apollo client:codegen ./Canvas/Infra/CanvasServer/CanvasAPI.swift --target=swift --queries=./Canvas/Infra/CanvasServer/canvas.app.graphql --localSchemaFile=./Canvas/Infra/CanvasServer/canvas.schema.graphql --namespace=CanvasAPI
	npx apollo client:codegen ./Canvas/Infra/NftServer/NftAPI.swift --target=swift --queries=./Canvas/Infra/NftServer/nft.app.graphql --localSchemaFile=./Canvas/Infra/NftServer/nft.schema.graphql --namespace=NftAPI

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