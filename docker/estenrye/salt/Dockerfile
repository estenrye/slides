FROM ubuntu:22.04 AS Base
ARG SALT_VERSION=3005.1-4
ADD https://repo.saltproject.io/salt/singlebin/${SALT_VERSION}/salt-${SALT_VERSION}-linux-amd64.tar.gz salt-linux-amd64.tar.gz
RUN cd /usr/bin && tar -xzvf /salt-linux-amd64.tar.gz

FROM ubuntu:22.04
ENV GIT_OPT_GET_SSL_CERT_LOCATIONS=/etc/ssl/certs
COPY --from=Base /usr/bin/salt /usr/bin/salt
RUN apt update && apt install -y \
      ca-certificates \
      libgit2-1.1 \
    && /usr/bin/salt pip install pygit2 \
    # workaround https://github.com/iterative/dvc/issues/7207
    && mkdir -p /etc/pki/tls \
    && ln -s /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/cert.pem
COPY etc/salt /etc/salt
ENTRYPOINT [ "/usr/bin/salt" ]

