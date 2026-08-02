# mirror-jqlang

OCX mirror for [jq](https://github.com/jqlang/jq). One repository, one spec
directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [jq](https://github.com/jqlang/jq) | [`jq/mirror.yml`](jq/mirror.yml) | `ghcr.io/ocx-contrib/jqlang/jq` | `ocx.sh/jqlang/jq` | `MIT` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> This repository previously published the same upstream to the flat coordinate
> `ocx.sh/jq` (as `mirror-jq`). `jqlang/jq` is the grouped successor — the
> namespace is upstream's own GitHub org.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
jq/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
```

`LICENSE` and `NOTICE.md` are shared at the root. Logos are **not** — each
package carries its own, because a repo-root `logo.*` sits in no workflow's
`paths:` filter, so replacing it would publish nothing until some unrelated
edit happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all.

## Platforms

`jq` publishes five platform entries: both Linux arches, both macOS arches and
`windows/amd64`. Upstream builds one Linux binary per arch and it is **fully
static** — no `PT_INTERP`, no `DT_NEEDED`, and no musl/glibc variants to choose
between. `os.features` states what an artifact requires *of the host*, so both
Linux keys are **bare**: tagging them `+libc.musl` would be a false requirement
that hid them from every glibc host. The `alpine:3.20` container leg in
`mirror-base.yml` is what turns that claim into evidence; the measurement
itself is recorded above the `assets:` block in `jq/mirror.yml`.

`windows/arm64` is **not** declared. `jq-windows-arm64.exe` first ships in
jq-1.8.2 and is absent from 1.7 … 1.8.1, so the key would resolve zero assets
on every earlier release — silently skipped, not an error, yielding a green run
with a missing platform.

The anchored `^…$` asset regexes deliberately do not match the legacy
`jq-linux64` / `jq-osx-amd64` / `jq-win64.exe` names that sit alongside the
modern `jq-<os>-<arch>` ones in every release.

The version floor is `versions.min: "1.7"`, carried over unchanged from the
flat layout. Measured with `pipeline plan`, that floor admits **1.8.0, 1.8.1,
1.8.2**. Two things the flat layout's comment had backwards: the `jq-1.7` tag
is unreachable at *any* floor (its two-component version does not survive
discovery), and the bare `"1.7"` floor is **stricter** than `"1.7.0"` — it
excludes `jq-1.7.1`, which does carry all five modern assets. Lowering the
floor to `"1.7.0"` is the one-line change that would add it.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `jq/mirror.yml` | hand | yes — see below |
| `jq/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `jq/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci --spec jq/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## The binaries claim

jq ships as a raw binary, so the bundle's only PATH entry is a bare
`${installPath}` — the executable *is* the content root. `bin_scan` only looks
*below* an `${installPath}/<dir>` entry, so `auto`/`verify` is rejected at spec
load with exit 65. `mirror-base.yml` therefore sets `bin_scan: off` and
`jq/metadata.json` hand-lists `binaries: ["jq"]` — the blessed shape for this
asset type.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope; each
package's redistribution license is recorded in [`NOTICE.md`](NOTICE.md).
