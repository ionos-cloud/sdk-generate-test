# Ionos Cloud SDK Github Action

This is a github action used for generating and testing Ionos Cloud SDKs.

# Parameters

| Parameter | Description | Required | Default Value |
|-----------|-------------|----------|---------------|
| version   | sdk version | yes      |               |
| ionos-vdc-user | Ionos Cloud user to use for tests | yes | |
| ionos-vdc-password | Ionos Cloud password to use for tests | yes | |
| codex-bucket | codex bucked to be used | yes | |
| codex-s3-key | s3 key to use to read from the bucket | yes | | 
| codex-s3-secret | s3 secret to use to read from the bucket | yes | |
| github-pat | github personal access token to use to clone the sdk repo | yes | |
| sdk-name | name of the sdk to generate | yes | |
| assets-dir | directory with sdk assets used to generate it | yes | |
| test-driver | test driver to use | yes | |
| test-suite | test suite to use | yes | |
| test-dir | directory with all the tests | yes | |
| test-runner-args | extra args passed to the test runner | no | `--fail-fast --batch` |
| java-version | java version to use | no | 1.8 |
| node-version | node version to use | no | 16 |

