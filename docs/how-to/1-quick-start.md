# Quick start

**⚠️ WARNING**

Use official Docker installation instead of using snap on Ubuntu, see [issue #5 ](https://github.com/gisiahq/gisia/issues/5)

## Start the Gisia services

Create the project folder

`mkdir gisia`

`cd gisia`

Init the config

`docker run --rm -v ./:/output gisia/init:0.3.1`

Modify and rename the `.env`

`cp .env.example .env`

Start the server

`docker compose up -d`

## Show the adminstrator initial password

```shell
docker exec -it gisia-web cat /rails/initial_root_password
```
## Update user password

1. login as user `root`
1. goto `/-/users/settings/password/edit`
1. change your password

## Create project

1. goto `/-/dashboard/projects`
1. create a new project


Next [How To Run Pipelines](2-run-pipelines.md)

