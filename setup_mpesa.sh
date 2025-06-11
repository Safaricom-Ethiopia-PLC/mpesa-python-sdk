#!/bin/bash

mkdir -p mpesa_python_sdk/auth mpesa_python_sdk/payments mpesa_python_sdk/utils tests

# Create the __init__.py files in relevant directories
for dir in mpesa_python_sdk mpesa_python_sdk/auth mpesa_python_sdk/payments mpesa_python_sdk/utils tests; do
	touch "$dir/__init__.py"
done

mkdir -p .github/workflows
