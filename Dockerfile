FROM --platform=$BUILDPLATFORM golang:1.26-alpine
WORKDIR /app

RUN go env -w GOCACHE=/go-cache

RUN apk update \
    && apk add --no-cache bash ca-certificates

ADD . /app

ENV DOCKER_ARCH=arm64
ENV GOOS=linux
ENV GOARCH=arm64
ARG STRESS_FILES=1200
ARG STRESS_LOOPS=25
ENV STRESS_FILES=$STRESS_FILES
ENV STRESS_LOOPS=$STRESS_LOOPS

RUN bash ./gen_stress.sh "$STRESS_FILES"

RUN --mount=type=cache,target=/go-cache set -e; i=1; while [ "$i" -le "$STRESS_LOOPS" ]; do echo "gofumpt pass $i/$STRESS_LOOPS"; go tool gofumpt -l -w .; i=$((i+1)); done
