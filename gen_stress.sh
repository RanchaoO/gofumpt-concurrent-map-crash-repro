#!/usr/bin/env bash
set -euo pipefail

count="${1:-800}"
root="stresspkg"
mkdir -p "$root"

for i in $(seq 1 "$count"); do
  f="$root/f_${i}.go"
  cat >"$f" <<EOF
package stresspkg

import (
  "fmt"
  "strings"
)

type T${i} struct {
  A int
  B string
  C []int
}

func F${i}(x int) string {
  vals := []T${i}{{A: x, B: "abc", C: []int{1,2,3,4,5}}, {A: x + 1, B: "def", C: []int{6,7,8,9}}}
  parts := make([]string, 0, len(vals))
  for _, v := range vals {
    if v.A%2 == 0 {
      parts = append(parts, fmt.Sprintf("%d-%s", v.A, v.B))
      continue
    }
    switch {
    case len(v.C) > 3:
      parts = append(parts, fmt.Sprintf("%d:%d", v.A, len(v.C)))
    default:
      parts = append(parts, "x")
    }
  }
  return strings.Join(parts, ",")
}
EOF
done
