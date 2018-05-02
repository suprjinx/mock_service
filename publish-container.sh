#!/bin/bash

# usage: ./publish-container.sh staging f0478bd7c2f584b41a49405c91a439ce9d944657
# license: public domain

# not used ATM
BRANCH=${1:-master}
SHA1=${2:-HEAD}

AWS_ACCOUNT_ID=620410916297
NAME=mock-service 

VERSION=latest
ZIP=$VERSION.zip

aws configure set default.region us-east-1

# Authenticate against our Docker registry
eval $(aws ecr get-login --no-include-email)

# Build and push the image
docker build -t $NAME:$VERSION .
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$NAME:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$NAME:$VERSION

# Replace the <AWS_ACCOUNT_ID> with the real ID
sed -i='' "s/<AWS_ACCOUNT_ID>/$AWS_ACCOUNT_ID/" Dockerrun.aws.json
# Replace the <NAME> with the real name
sed -i='' "s/<NAME>/$NAME/" Dockerrun.aws.json
# Replace the <TAG> with the real version number
sed -i='' "s/<TAG>/$VERSION/" Dockerrun.aws.json

