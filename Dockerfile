FROM alpine:3.10.3 AS builder

RUN apk add -U --no-cache ca-certificates 
RUN adduser -s /bin/true -u 1000 -D -h /go gabi \
    && sed -i -r "/^(gabi|root)/!d" /etc/group /etc/passwd \
    && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd
FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/group /etc/shadow /etc/

USER gabi

ENTRYPOINT ["/go/main"]
