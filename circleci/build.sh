#!/bin/bash

set -eux

./godelw verify --apply=false --junit-output="${ARTIFACT_STORE}/tests.xml"
./godelw dist

version=$(./godelw project-version)

# We need to trust duosecurity.com, so let's just use system CA certs
# The machine pre section makes sure we've got the latest from apt
cp /etc/ssl/certs/ca-certificates.crt .

docker build \
    -t palantirtechnologies/duo-bot:${version} \
    --build-arg VERSION=$version \
    -f Dockerfile \
    .

# Otherwise our version tags will say we're dirty
rm -f ca-certificates.crt