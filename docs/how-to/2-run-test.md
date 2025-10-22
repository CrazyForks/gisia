# How to run test

1. register a runner
1. config your pipeline

## How to register a runner

1. login as admin
1. goto `/admin/runners`
1. click on the button `New instance runner`
1. click on the button `Create Runner`
1. pull the runner docker image by `docker pull gitlab/gitlab-runner:v18.2.1`
1. start the runner `docker run -d -v /var/run/docker.sock:/var/run/docker.sock --name gisia-docker-runner gitlab/gitlab-runner:v18.2.1`
1. copy and run `docker exec -it gisia-docker-runner gitlab-runner register --url http://nix.test:8080 --token YOUR-RUNNER-TOKEN`
1. click on the `View Runners` button, you should see your runner is online


## How to config the pipeline yaml file for a project

1. goto `/-/dashboard/projects`
1. choose or create a project
1. use git to clone this project
1. create `.gitlab-ci.yml` and commit with the following content
1. then a pipeline should be created
### .gitlab-ci.yml
```yaml
test-job:
  script:
    - echo "Test is running..."
    - echo "Test done"
```
