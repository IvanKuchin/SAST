FROM python:3

LABEL com.github.actions.name="cpp-flaw-finder"
LABEL com.github.actions.description="examines C/C++ source code and reports possible security weaknesses"
LABEL com.github.actions.icon="life-buoy"
LABEL com.github.actions.color="blue"

LABEL repository="https://github.com/IvanKuchin/SAST/"
LABEL maintainer="ivan.kuchin@gmail.com"

RUN apt-get update
RUN apt-get -qq -y install curl jq

RUN pip install flowfinder

COPY ./src/entrypoint.sh /entrypoint.sh
COPY ./src/log.sh /log.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
