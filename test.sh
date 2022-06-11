#!/bin/bash


echo -n "Enter your GitHub username (lowercase): "
read username

if [ ! -z "$username" ]; then
    if [ $(curl -s -I "https://api.github.com/users/$username" | head -n 1 | cut -d' ' -f2) = "200" ]; then
        echo "User exists!"
    else
        echo "User does not exist!"
    fi
else
    echo "Please enter a username!"
fi

echo "Before inserting your repository name, make sure you have successfully created a new repository on https://github.com/new for the next steps."
echo "Enter your repository name:"
read repository