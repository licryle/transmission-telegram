FROM --platform=$BUILDPLATFORM docker.io/golang:alpine AS build

ARG TARGETOS=linux
ARG TARGETARCH
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV CGO_ENABLED=0

RUN apk add --no-cache git

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o /out/transmission-telegram .

FROM docker.io/alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=build /out/transmission-telegram /transmission-telegram

ENTRYPOINT ["/transmission-telegram"]
