## Title

Go 1.26/arm64: runtime crash during `go tool gofumpt -l -w .` under file-level concurrency pressure

## Summary

In Docker (`golang:1.26-alpine`) targeting `linux/arm64`, `go tool gofumpt -l -w .` fails with runtime-level fatal errors when formatting a stress corpus (many files + repeated passes).

I can reproduce this consistently with the attached minimal repo and command below.

## Environment

- Go toolchain: `go1.26`
- gofumpt: `mvdan.cc/gofumpt@v0.9.1`
- Base image: `golang:1.26-alpine`
- Target: `GOOS=linux`, `GOARCH=arm64`
- Host: Windows + Docker Desktop

## Minimal repro

- Repo: `RanchaoO/gofumpt-concurrent-map-crash-repro`
- Core files: `Dockerfile`, `docker-compose.yaml`, `gen_stress.sh`

## Reproduction steps

```bash
docker compose build --no-cache 2>&1 | tee repro-stress.log
```

Current stress args in compose:

- `STRESS_FILES=2000`
- `STRESS_LOOPS=40`

## Expected behavior

`gofumpt` completes formatting and exits successfully.

## Actual behavior

Build fails in the gofumpt step with exit code 2 and runtime fatal traces.

Representative log markers:

- `fatal error: found pointer to free object`
- `runtime.throw(...)`
- `failed to solve: ... did not complete successfully: exit code: 2`

## Attachments

- `repro-stress.log` (full output)
- `GOLANG_BUG_REPORT_SHORT.md` (short post version)

## Additional context

- In a larger production repository, the failure signature is sometimes `fatal error: concurrent map read and map write`.
- In this minimal stress repro, the exact fatal signature may vary run-to-run, but failure remains in gofumpt processing under high stress.
- If this is considered gofumpt-owned rather than Go runtime-owned, please advise and I will file in the correct tracker.
