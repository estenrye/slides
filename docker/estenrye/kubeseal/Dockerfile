FROM golang:latest as build
LABEL maintainer="Esten Rye <esten.rye+docker@ryezone.com>"
ARG VERSION="0.18.1"
WORKDIR /app
ADD https://github.com/bitnami-labs/sealed-secrets/archive/refs/tags/v${VERSION}.tar.gz /app/src.tar.gz
RUN tar -xzvf /app/src.tar.gz
WORKDIR /app/sealed-secrets-${VERSION}/cmd/kubeseal
RUN GO111MODULE=on CGO_ENABLED=0 go build -ldflags "-X main.VERSION=v${VERSION}" -o /app/kubeseal -a

FROM scratch
WORKDIR /
COPY --from=build /app/kubeseal kubeseal
ENTRYPOINT [ "/kubeseal" ]
