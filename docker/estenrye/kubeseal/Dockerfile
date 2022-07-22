FROM golang:latest as build
LABEL maintainer="Esten Rye <esten.rye+docker@ryezone.com>"
WORKDIR /app
ARG VERSION="main"
RUN GO111MODULE=on CGO_ENABLED=0 go install -a github.com/bitnami-labs/sealed-secrets/cmd/kubeseal@${VERSION}
COPY src src
RUN /app/src/scripts/download-latest-kubectl.sh

FROM scratch
WORKDIR /
ENV PATH=/
COPY --from=build /go/bin/kubeseal /app/kubectl /
CMD [ "kubeseal", "--version" ]
