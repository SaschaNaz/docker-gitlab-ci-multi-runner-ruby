FROM gitlab/gitlab-runner
MAINTAINER Kagami Sascha Rosylight <saschanaz@outlook.com>

RUN apt-get update

# install build essentials
RUN apt install -y --no-install-recommends \
	git-core \
	maven \
	mysql

RUN chown -R ${GITLAB_CI_MULTI_RUNNER_USER}:${GITLAB_CI_MULTI_RUNNER_USER} ${GITLAB_CI_MULTI_RUNNER_HOME_DIR}

RUN locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV RUNNER_DESCRIPTION=itrust
ENV RUNNER_DESCRIPTION=shell
ENV RUNNER_TAG_LIST=itrust
ENV RUNNER_LIMIT=1

ENV RUNNER_TOKEN=
ENV CI_SERVER_URL=
