FROM golang:1.24.4-bookworm AS tools-builder

COPY patcher patcher
RUN go build -C patcher
COPY healthcheck healthcheck
RUN go build -C healthcheck

FROM tsxcloud/steamcmd-wine-ntsync:latest

VOLUME /server

COPY --from=tools-builder /go/patcher/patcher /usr/local/bin/patcher
COPY --from=tools-builder /go/healthcheck/healthcheck /usr/local/bin/healthcheck
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chmod +x /usr/local/bin/patcher && chmod +x /usr/local/bin/healthcheck
HEALTHCHECK --interval=1m --timeout=10s --start-period=5m --start-interval=15s --retries=2 CMD healthcheck localhost:7777
ENTRYPOINT []
CMD ["/entrypoint.sh"]


