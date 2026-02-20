# gofumpt repro report

## Environment

- Go: 1.26 (golang:1.26-alpine)
- gofumpt: v0.9.1
- Target: GOOS=linux, GOARCH=arm64
- Host: Windows + Docker Desktop

## Repro command

```bash
docker compose build --no-cache 2>&1 | tee repro-stress.log
```

## Stress settings

- STRESS_FILES=2000
- STRESS_LOOPS=40

## Result

Build fails during gofumpt phase with exit code 2.

Key markers in log (`repro-stress.log`):

- `fatal error: found pointer to free object`
- `runtime.throw(...)`
- `did not complete successfully: exit code: 2`

## Notes

- This minimal repo intentionally amplifies file-level concurrency by generating many Go files at build time.
- Failure signature may vary between runs (runtime/gc related fatal errors or other gofumpt-internal crash signatures), but it consistently fails inside the gofumpt phase under stress.
