#!/bin/bash

## If you need to generate private key and certificate using passphrase . set environment variable CERT_PRIVATE_KEY_PWD
# export CERT_PRIVATE_KEY_PWD="your-passphrase"

ansible-playbook main-playbook.yml
