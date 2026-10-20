# caddy-cloudflare

[![CI](https://github.com/jharris4/caddy-cloudflare/actions/workflows/ci.yml/badge.svg)](https://github.com/jharris4/caddy-cloudflare/actions/workflows/ci.yml)

Caddy built with the [`caddy-dns/cloudflare`](https://github.com/caddy-dns/cloudflare)
module, for ACME DNS-01 challenges against Cloudflare. Published for
`linux/amd64` and `linux/arm64` as `ghcr.io/jharris4/caddy-cloudflare:<version>`.

## The token

The entrypoint reads the Cloudflare API token from a file and exports it as
`CF_API_TOKEN` before starting Caddy, so the token never appears in the
container's environment config. Mount it at `/run/secrets/cloudflare_api_token`,
or point `CF_API_TOKEN_FILE` somewhere else. Without a readable token file the
container exits instead of starting.

Reference it from the Caddyfile as `{env.CF_API_TOKEN}`:

```
tls {
	dns cloudflare {env.CF_API_TOKEN}
}
```

## Releasing

1. Bump `CADDY_VERSION` in the `Dockerfile` (and the plugin version, if it has
   moved) and push to `main`. CI builds both platforms.
2. Tag the commit `vX.Y.Z`, matching `CADDY_VERSION`, and push the tag. The
   release workflow publishes `ghcr.io/jharris4/caddy-cloudflare:X.Y.Z`.

To rebuild the same Caddy version, for a plugin bump, tag it `vX.Y.Z-rN`.
There is no `:latest` tag.
