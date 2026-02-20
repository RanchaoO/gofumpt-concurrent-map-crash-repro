gofumpt-concurrent-map-crash-repro
Minimal reproducible example for a gofumpt crash in Docker.

This repository is intentionally minimal and not production code.

Summary
Running go tool gofumpt -l -w . inside Docker crashes with:

fatal error: concurrent map read and map write
stack traces pointing into mvdan.cc/gofumpt@v0.9.1
The same workflow in a larger production repo fails at the same stage; this repo isolates it to a minimal setup.

Environment
Go: 1.26.0
gofumpt: v0.9.1
Base image: golang:1.26-alpine
Target: GOOS=linux, GOARCH=arm64
Host OS: Windows (Docker Desktop)
Reproduction
Build with no cache:

docker compose build --no-cache
Observe failure during:

go tool gofumpt -l -w .
Expected behavior
gofumpt formats files and exits successfully.

Actual behavior
gofumpt panics and exits with code 2, with stack traces such as:

mvdan.cc/gofumpt@v0.9.1/...
fatal error: concurrent map read and map write
Minimal files in this repo
main.go (tiny HTTP handler + inline cache-control middleware)
go.mod
Dockerfile
docker-compose.yaml
Notes
No frontend build.
No external service dependencies.
Repro is focused only on Docker + gofumpt behavior.
