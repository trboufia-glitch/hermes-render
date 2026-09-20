#!/bin/bash
set -e
mkdir -p /app/.hermes
envsubst < /app/hermes-config.yaml.template > /app/.hermes/config.yaml
exec hermes gateway run
