# NOTICE

This repository packages and redistributes upstream software published by the
[jqlang](https://github.com/jqlang) organisation. The Apache-2.0 license in
[`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `jq` | `ghcr.io/ocx-contrib/jqlang/jq` | `MIT` |

---

## `jq`

Upstream: <https://github.com/jqlang/jq>
Published to `ghcr.io/ocx-contrib/jqlang/jq`.

| Component | SPDX | Holder |
|---|---|---|
| jq (`jq`) | **MIT** | jq is copyright (C) 2012 Stephen Dolan |

Permissive; redistribution of the compiled binary is granted provided the
copyright notice and permission notice are retained. Upstream's license file is
named [`COPYING`](https://github.com/jqlang/jq/blob/master/COPYING) and carries
the MIT text verbatim for the software, followed by a separate CC BY 3.0 grant
that applies only to the `docs/` tree — which this mirror does not redistribute.
GitHub's license API answers `NOASSERTION` for that combined file; the SPDX id
above is from reading it. Upstream ships raw binaries with no bundled license
file, so the notice is reproduced here and the terms are those of `COPYING`.
The published binaries statically link permissively licensed third-party
libraries (oniguruma, BSD-2-Clause; decNumber, ICU).

The jq name is used for catalog identification under nominative fair use. The
logo shipped with this package is sourced from upstream's
`docs/public/icon.svg` and remains a mark of the jq authors / jqlang.

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.
