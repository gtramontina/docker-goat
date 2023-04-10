FROM golang:alpine3.17 as build
ARG version
WORKDIR /opt
ENV GOBIN=/opt/bin
RUN go install github.com/blampe/goat/cmd/goat@$version

# ---

LABEL org.opencontainers.image.source https://github.com/gtramontina/docker-goat
LABEL org.opencontainers.image.description "Container for goat https://github.com/blampe/goat"
FROM scratch
COPY --from=build /opt/bin/goat /goat
ENTRYPOINT ["/goat"]
