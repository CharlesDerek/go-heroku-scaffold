#!/bin/bash

CWD=${PWD##*/}

#Install Golang:
if ! type "go" > /dev/null; then
   echo "Go is not installed. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        sudo brew install -y go
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        # linux
        sudo apt-get -y install golang
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        echo "Install go for freebsd systems"
        sudo pkg install -y go
        echo "FreeBSD is not supported."
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows:
        echo "Install go for windows (cygwin)"
        curl -O https://storage.googleapis.com/golang/go1.4.2.windows-amd64.msi
        msiexec /i go1.4.2.windows-amd64.msi
        echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW):
        echo "Install go for windows (msys)"
        curl -O https://storage.googleapis.com/golang/go1.4.2.windows-amd64.msi
        msiexec /i go1.4.2.windows-amd64.msi
        echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
    elif [[ "$OSTYPE" == "win32" ]]; then
        # windows (win32)):
        echo "Error: Go is not supported on 32 bit operating systems."
        exit 1
    else
        echo "Error: Unknown Operating System."
        exit 1
    fi
else
   echo "Go is installed."
fi


echo -n "Enter your GitHub username (lowercase): "
read username


if [ ! -z "$username" ]; then
    if [ $(curl -s -I "https://api.github.com/users/$username" | head -n 1 | cut -d' ' -f2) = "200" ]; then
        # If the user exists, continue:
        echo "Hello $username"
    else
        echo "We were not able to verify that your username $username exists on github.com."
        echo "Please try again verifying your name is correct and exists on github.com."
        exit 1
    fi
else
    echo "We recieved an empty reponse."
    echo "A valid username is required to proceed."
    echo "Please restart this process, and try again."
    exit 1
fi

echo "Before inserting your repository name, make sure you have successfully created a new repository on https://github.com/new for the next steps."
echo "Enter your repository name:"
read repository

#Validate the repository name (heroku app name) is not already taken:
if [ -z "$repository" ]
then
    echo "Please provide a valid repository/app name."
    exit 1
fi

echo "Your GitHub username is: $username"
echo "Your repository name is: $repository"

# Rename CWD && S&R configs to new repository name:
if [ "$CWD" != "$repository" ]; then
    cd ../
    mv $CWD $repository
    CWD=$repository
    cd $CWD
    # Rename S&R configs to new repository name:
    for file in *
    do
        if [ -f "$file" ]
        then
            sed -i "s/bookings-path-23948932890/$repository/g" "$file"
        fi
    done
fi

# create a new golang web app on github
if [ -d ".git" ]; then
    echo "The .git repository has already been initialized..."
    echo "Continuing..."
else
    echo "The .git has not been initialized. Initializing..."
    git init
    git add .
    git commit -m "initial commit"
    git branch -M main
    git remote add origin git@github.com:$username/$repository.git
    git push -u origin main
    git remote add master
    echo "The .git repository has been initialized."
fi

# Have Curl installed:
if ! type "curl" > /dev/null; then
    echo "Curl is not installed. Installing..."
    sudo apt install curl
    echo "Curl is now installed."
fi

# Have heroku CLI installed:
if ! type "heroku" > /dev/null; then
    echo "Heroku CLI is not installed. Installing..."
    curl https://cli-assets.heroku.com/install.sh | sh
    echo "Heroku CLI is now installed."
fi

# check if user is logged in to heroku:
if heroku --version; then
    echo "heroku is already logged in, proceeding.."
else
    echo "heroku is not logged in, Logging in..."
    heroku login
    echo "heroku is now logged in."
fi

# create a new heroku app (if not already created):
if [ -d "/app/.heroku" ]; then
    echo "The project has already been created. Continuing..."
else
    echo "The project has not been created yet. Creating $repository now..."
    if [ heroku apps:info $repository -ne 0 ]
    then
        echo "Herku name status 200! The app name $repository is available"
        repository_heroku=$repository
    else
        echo "Heroku name status 409 (already exists).."
        repository_heroku=$repository
        while [ heroku apps:info $repository_heroku -ne 0 ]
        do
            echo "The app name $repository_heroku is already taken. Let's try another one name:"
            read repository_heroku
            if [ heroku apps:info $repository_heroku -ne 0 ]
            then
                echo "Success! The app name $repository_heroku is available"
                git remote rm heroku
                git remote add heroku https://git.heroku.com/$repository_heroku.git
                break
            else
                echo "The app name $repository_heroku is already taken"
            fi
        done
    fi
    heroku create $repository_heroku
fi

# push the code to heroku
git push heroku main
