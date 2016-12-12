# Docker image with gitlab-ci-multi-runner to run builds with NCSU iTrust

Docker image with gitlab-ci-multi-runner, which can run iTrust Maven builds.

## How to use

```
docker run -d --env "CI_SERVER_URL=https://gitlabci.example.com" \
              --env "RUNNER_TOKEN=YOUR_TOKEN_FROM_GITLABCI" \
              --restart="always" \
              --name=ruby_runner \
              saschanaz/docker-gitlab-runner-itrust:latest
```

In your project add `.gitlab-ci.yml`

```yaml
.validate: &validate
  stage: build
  script:
    - 'mvn $MAVEN_CLI_OPTS test-compile -f iTrust/pom.xml'

.verify: &verify
  stage: test
  script:
    # - 'service mysql status'
    - 'pushd iTrust;mvn $MAVEN_CLI_OPTS verify;popd'

# Validate merge requests using JDK8
validate:jdk8:
  <<: *validate
  image: maven:3.3.9-jdk-8

# Verify merge requests using JDK8
verify:jdk8:
  <<: *verify
  image: maven:3.3.9-jdk-8
```

## More information

* Read about [gitlab-ci-multi-runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/) to learn how integration works with GitLab CI.
* This image is based on [docker-gitlab-ci-multi-runner](https://github.com/digitallumberjack/docker-gitlab-ci-multi-runner), which handles registration and startup.
