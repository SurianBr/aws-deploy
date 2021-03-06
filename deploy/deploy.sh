#!/bin/bash
echo "Busca nome da stack"
STACK=$(jq '.nome' -r pipeline.json)
echo ${STACK}

echo "Valida template"
cfn-lint "${GITHUB_WORKSPACE}/infra/template.yml" --no-fail-on-empty-changeset
if [ $? -ne 0 ]; then
    echo "Erro no lint"
    exit -1
else
    echo "Template ok"
fi

echo 'Fazendo deploy da pipe'
aws cloudformation deploy --template-file "${GITHUB_WORKSPACE}/infra/template.yml" --stack-name ${STACK}