FROM golang:1.17.6 AS build
WORKDIR /go/src/ingress_default_backend
COPY go.mod .
COPY server.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ingress_default_backend server.go

FROM scratch
EXPOSE 8080
COPY templates ./templates
COPY --from=build /go/src/ingress_default_backend/ingress_default_backend /ingress_default_backend
ENTRYPOINT ["/ingress_default_backend"]