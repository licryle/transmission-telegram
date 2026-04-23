FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETOS=linux
ARG TARGETARCH
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV CGO_ENABLED=0

RUN apk add --no-cache git

WORKDIR /src
COPY . .

RUN go mod init transmission-telegram || true
RUN go mod tidy
RUN go build -o /out/transmission-telegram .

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=build /out/transmission-telegram /transmission-telegram

ENTRYPOINT ["/transmission-telegram"]
