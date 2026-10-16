# tf-state-bootstrap

> **Reference configuration.** Only **validated**, never planned or applied: there is no AWS account behind it. On GitHub Actions the workflow runs `fmt -check`, `init -backend=false` and `validate` (which downloads the AWS provider and checks every resource and attribute against its schema), and that **succeeded** on 2026-10-16. Whether the resources create correctly, and whether the S3 backend block works, is not tested.

The chicken-and-egg step of Terraform on AWS: before anything can use remote state, a state bucket must exist. This creates it safely, once, with local state.

## What it creates (`bootstrap/`)

| Resource | Why |
|---|---|
| S3 bucket with `prevent_destroy` | losing it means losing every state file |
| Versioning | roll back a corrupted or deleted state file |
| SSE-KMS encryption | state can contain secrets in plain text |
| Public access block | state must never be public |
| Bucket policy denying non-TLS | encrypted in transit only |

`example-app/backend.tf` shows how any other root module points at the bucket, with **`use_lockfile = true`** (S3-native locking, Terraform 1.10 or later), so no DynamoDB table is needed.

## Why remote state with locking

A shared state file is how a team knows what exists. Without locking, two applies at once can corrupt it. Without versioning, one bad write is unrecoverable.

## Honest limits

- **Not applied, not planned.** `validate` passing means the configuration is well-formed, not that it is correct or that the names are free.
- **The bootstrap's own state is local**, so it must be kept or imported; teams often move it into the bucket it created afterwards.
- No KMS key policy, no access logging, no lifecycle rule to expire old state versions, no cross-region replication.
- `.terraform.lock.hcl` is not committed (the provider was not downloaded locally); run `terraform init` and commit it.
- Whether to use S3-native locking or the older DynamoDB lock depends on the Terraform version the customer runs.

MIT licensed.
