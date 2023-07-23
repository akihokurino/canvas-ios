ENV_PATH=.env
source ${ENV_PATH}
export $(cut -d= -f1 ${ENV_PATH})
envsubst < template.xcconfig > Canvas/Config.xcconfig