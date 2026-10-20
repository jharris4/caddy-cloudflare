# The image tag published by release.yml is this version, so bump it here and
# tag the commit vX.Y.Z to release.
ARG CADDY_VERSION=2.11.7

# The builder always runs on the build host's own platform and cross-compiles
# for the target. Go does that natively, so the arm64 image builds as fast as
# the amd64 one instead of compiling all of Caddy under QEMU emulation.
FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder AS builder

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
    --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare@v0.2.4

FROM caddy:${CADDY_VERSION}-alpine

# COPY only, no RUN: nothing in this stage executes under emulation either.
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --chmod=0755 docker-entrypoint.sh /usr/bin/caddy-with-secrets

ENTRYPOINT ["/usr/bin/caddy-with-secrets"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
