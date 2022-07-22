FROM golang:latest as build
LABEL maintainer="Esten Rye <esten.rye+docker@ryezone.com>"
WORKDIR /app
ARG VERSION="main"
RUN GO111MODULE=on CGO_ENABLED=0 go install -a github.com/bitnami-labs/sealed-secrets/cmd/kubeseal@${VERSION}
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(uname -m)/kubectl"
RUN chmod 555 /app/kubectl /go/bin/kubeseal

FROM scratch
WORKDIR /
COPY --from=build /go/bin/kubeseal kubeseal
COPY --from=build /app/kubectl kubectl
CMD [ "/kubeseal", "--version" ]
