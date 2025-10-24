# Quick start

## Start the Gisia services

Init the config

`docker run --rm -v ./:/output gisia/init:0.1.0`

Modify and rename the `.env`

`cp .env.example .env`

Start the server

`docker compose up -d`

## Show the adminstrator initial password

```shell
docker exec -it gisia-web cat /rails/initial_root_password
```
## Update user password

1. login
1. goto `/-/users/settings/password/edit`
1. change your password

## Create project

1. goto `/-/dashboard/projects`
1. create a new project
