# jq/tests/smoke.star — stable across upstream releases.
# Assert on the contract (exit code, version shape, computed result), never on
# help/version prose. jq's banner and manual text are upstream's to reword; the
# digits and the values it computes are the contract. jq is a pure-compute CLI
# with no declared non-PATH env var, so its full contract is Tiers 1-3.
JQ = "jq.exe" if ocx.target_platform.os == ocx.os.Windows else "jq"

# Tier 1 + 2: liveness + version SHAPE. jq prints `jq-1.8.2` on current
# releases, but upstream also tags two-component versions (`jq-1.7`), so the
# shape match stops at the minor component rather than assuming a patch digit
# — stable across the mirror's lifetime whatever the floor admits.
r_version = ocx.run(JQ, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+")

# Tier 3a: parse → evaluate → emit over real JSON on stdin, asserting a value
# no stub could fake without actually running the reduction. Anchored so a
# substring match on some longer number cannot pass it.
r_add = ocx.run(JQ, "-c", ".a | add", stdin = '{"a":[1,2,3]}')
expect.ok(r_add)
expect.matches(r_add.stdout, r"^6\s*$")

# Tier 3b: raw string extraction — `-r` must emit the bare value, not a quoted
# JSON string. Fails if the output encoder regresses.
r_raw = ocx.run(JQ, "-r", ".value", stdin = '{"value": "ok"}')
expect.ok(r_raw)
expect.matches(r_raw.stdout, r"^ok\s*$")
