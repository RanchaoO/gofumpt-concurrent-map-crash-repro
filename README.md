gofumpt-concurrent-map-crash-repro

Minimal stress repro for `mvdan.cc/gofumpt@v0.9.1` on Go 1.26 (alpine, arm64 target).

This repo intentionally keeps only files needed to reproduce failures in:

`go tool gofumpt -l -w .`

Environment

- Go: 1.26
- gofumpt: v0.9.1
- Base image: golang:1.26-alpine
- Target: GOOS=linux, GOARCH=arm64

How it works

- `gen_stress.sh` generates many Go files under `stresspkg/` during Docker build.
- Docker then runs gofumpt in multiple passes to amplify concurrency pressure.

Reproduce

1. `docker compose build --no-cache`
2. Full output is saved with:
   `docker compose build --no-cache 2>&1 | tee repro-stress.log`

Tune stress level (in `docker-compose.yaml` build args)

- `STRESS_FILES` (default 2000)
- `STRESS_LOOPS` (default 40)

Expected

- gofumpt finishes successfully.

Actual (intermittent)

- gofumpt exits with code 2 and runtime/gofumpt stack traces.
