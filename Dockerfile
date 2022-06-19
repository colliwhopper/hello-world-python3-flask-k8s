# offical slim (debian) python3 image
FROM python:3.11.0b3-slim-bullseye

# update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --assume-yes apt-utils curl

# clean apt cache
RUN rm -rf /var/cache/apt/*

# set timezone
RUN rm -rf /etc/localtime && ln -fs /usr/share/zoneinfo/GMT /etc/localtime && date +%Z

# create user to aid in securing app
ARG user=helloworld_svc
ARG group=helloworld
ARG uid=1001
ARG gid=1001

# create app user
RUN groupadd -g ${gid} ${group} \
  && useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# create app dir and set ownership
RUN mkdir /app \
  && chown -R ${user}:${group} /app

# copy Python Script Across
COPY --chown=${user}:${group} /src /app
RUN pip3 install -r /app/requirements.txt

# set workdir
WORKDIR /app

# expose service port
EXPOSE 8080

# switch to app user
USER ${user}

# run app
CMD ["python", "-u", "hello-world.py"]
