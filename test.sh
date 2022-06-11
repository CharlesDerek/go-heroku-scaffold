#!/bin/bash

if [[ "$(ssh -T git@github.com)" == *"successfully authenticated"* ]]; then
    username="$(echo "$(ssh -T git@github.com)" | cut -d' ' -f 3 | tr '[:upper:]' '[:lower:]')"
    echo "username is: $username"
else
    echo "Not signed in"
fi