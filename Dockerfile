FROM rockylinux:9

RUN echo "Hello world"

WORKDIR /app

RUN dnf upgrade \
    --assumeyes \
    --refresh \
    --best \
    --nodocs \
    --noplugins \
    --setopt=install_weak_deps=0 \
 && dnf install -y --nodocs \
   dnf-plugins-core \
 && echo "crb (powertools) is required by libpcap-devel" \
 && dnf config-manager \
   --enable crb \
 && dnf install -y --nodocs \
    lksctp-tools-devel \
    libpcap \
    tar \
    which \
    sudo \
 && dnf install -y https://rpmfind.net/linux/epel/9/Everything/x86_64/Packages/h/hiredis-1.0.2-1.el9.x86_64.rpm \
 && dnf install -y https://rpmfind.net/linux/epel/9/Everything/x86_64/Packages/c/ccache-4.5.1-2.el9.x86_64.rpm \
 && dnf clean all \
 && rm -rf /var/cache/yum

COPY --chmod=0755 ./Dockerfile /app/Dockerfile

RUN cat Dockerfile

ARG USER_ID
ARG GROUP_ID
RUN groupdel -f $(getent group ${GROUP_ID} | cut -d: -f1) || true
RUN userdel -r $(id -nu ${USER_ID}) || true
RUN groupadd -g ${GROUP_ID} devenv && useradd -m -u ${USER_ID} -g devenv devenv \
 && chown -R devenv:devenv /home/devenv Dockerfile

RUN ls -la Dockerfile