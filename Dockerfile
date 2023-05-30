FROM rockylinux:9-minimal

RUN echo "Hello world"

COPY . .

RUN cat Dockerfile

ARG USER_ID
ARG GROUP_ID
RUN groupdel -f $(getent group ${GROUP_ID} | cut -d: -f1) || true
RUN userdel -r $(id -nu ${USER_ID}) || true
RUN groupadd -g ${GROUP_ID} devenv && useradd -m -u ${USER_ID} -g devenv devenv \
 && chown -R devenv:devenv /home/devenv Dockerfile

RUN ls -la Dockerfile