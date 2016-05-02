#!/bin/bash

echo 'start installation...'

# Ruby : Itamae, Serverspec, unix-crypt, etc
bundle install --path vendor/bundle

# Python : AWS CLI, Fabric, wakatime, etc
pip install -r requirements.txt

# Golang : とりあえず手動でパッケージインストールする
go get -u github.com/aws/aws-sdk-go

echo 'end installation!'
