FROM golang:1.13.5-alpine3.11 AS builder

COPY healthcheck.go /go/src/

RUN GOOS=linux GOARCH=386 go build -o /go/bin/healthcheck /go/src/healthcheck.go

RUN apk add -U --no-cache ca-certificates 
RUN adduser -s /bin/true -u 1000 -D -h /go gabi \
    && sed -i -r "/^(gabi|root)/!d" /etc/group /etc/passwd \
    && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

FROM scratch
COPY --from=builder /go/bin/healthcheck /go/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/group /etc/shadow /etc/

USER gabi

ENTRYPOINT ["/go/main"]
