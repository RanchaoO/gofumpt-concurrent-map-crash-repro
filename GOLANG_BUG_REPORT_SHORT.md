Go 1.26 + `golang:1.26-alpine` + `linux/arm64`: `go tool gofumpt -l -w .` crashes in a minimal stress repro.

I can reproduce with:

```bash
docker compose build --no-cache 2>&1 | tee repro-stress.log
```

Repro repo: `RanchaoO/gofumpt-concurrent-map-crash-repro`

Current stress settings:

- `STRESS_FILES=2000`
- `STRESS_LOOPS=40`

Observed failures are in the gofumpt phase (`mvdan.cc/gofumpt@v0.9.1`) with exit code 2; representative markers include:

- `fatal error: found pointer to free object`
- `runtime.throw(...)`

In a larger production repo, we also see intermittent `fatal error: concurrent map read and map write` during the same gofumpt phase.

Attachments:

- `repro-stress.log` (full)
- `GOLANG_BUG_REPORT.md` (full report)
