# Ionos Cloud SDK Github Action

This is a github action used for generating and testing Ionos Cloud SDKs.

# Prerequisites

The action needs to have the following installed
- node >= 16  with the `ionos-cloud` scope configured
- java >= 1.8

You can do this by adding the following snippet to your workflow:
```
- name: Setting up Node 16
  uses: actions/setup-node@v1
	with:
      node-version: 16
      registry-url: https://npm.pkg.github.com/
      scope: '@ionos-cloud'

- name: Setting up JDK 1.8
  uses: actions/setup-java@v1
    with:
      java-version: 1.8
```

# Parameters

| Parameter | Description | Required | Default Value |
|-----------|-------------|----------|---------------|
| version   | sdk version | yes      |    V6.0.0     |
| ionos-vdc-user | Ionos Cloud user to use for tests | yes | |
| ionos-vdc-password | Ionos Cloud password to use for tests | yes | |
| codex-s3-bucket | codex bucked to be used | yes | |
| codex-s3-key | s3 key to use to read from the bucket | yes | | 
| codex-s3-secret | s3 secret to use to read from the bucket | yes | |
| node-auth-token | token used for auth with the github npm registry - always use `${{ secrets.GITHUB_TOKEN }}`| yes | |
| github-pat | github personal access token to use to clone the sdk repo | yes | |
| sdk-name | name of the sdk to generate | yes | |
| sdk-folder | folder in which to generate the sdk in the new repo | yes | |
| artifact-id | artifactId in generated pom.xml. This also becomes part of the generated library's filename | no | |
| sdk-branch | name of branch where to generate the sdk | yes |  |
| assets-dir | directory with sdk assets used to generate it | yes | |
| test | whether to run tests or not | no | true |
| test-driver | test driver to use | yes | |
| test-suite | test suite to use | yes | |
| test-dir | directory with all the tests | yes | |
| test-runner-args | extra args passed to the test runner | no | `--fail-fast --batch` |
| java-version | java version to use | no | 1.8 |
| node-version | node version to use | no | 16 |
| git-versioning | whether to create git tag and branch (if needed) or not | no | false |

**NOTE**: All paths should be relative to your github workspace i.e don't send in absolute paths.

# Outputs

| Output | Description |
|--------|-------------|
| `sdk-dir` | Path to the generated sdk directory |

# Example usage

_Note_: env and inputs are assumed to be set up, as well as node and java.


```
      - id: gen-test
        name: Generating and testing the sdk
        uses: ionos-cloud/sdk-generate-test@v2
        with:
          sdk-name: ${{ env.sdk-name }}
          sdk-folder: ${{ env.sdk-folder }}
          version:  ${{ github.event.inputs.version }}
          sdk-branch: ${{ env.sdk-branch }}
          ionos-vdc-user: ${{ secrets.IONOS_VDC_USER }}
          ionos-vdc-password: ${{ secrets.IONOS_VDC_PASSWORD }}
          codex-s3-bucket: ${{ env.codex-s3-bucket }}
          codex-s3-key: ${{ secrets.CODEX_S3_KEY }}
          codex-s3-secret: ${{ secrets.CODEX_S3_SECRET }}
          node-auth-token: ${{ secrets.GITHUB_TOKEN }}
          github-pat: ${{ secrets.PAT }}
          assets-dir: resources/assets/${{ env.assets-dir }}
          test-driver: ${{ env.test-driver }}
          test-suite: ${{ github.event.inputs.test-suite }}
          test-dir: resources/tests
          test-runner-args: ${{ github.event.inputs.test-runner-args }}
          test: ${{ github.event.inputs.run-tests == 'yes' }}

      - name: Archiving the sdk
        uses: actions/upload-artifact@v2
        with:
          name: ${{ env.sdk-name }}
          path: ${{ steps.gen-test.outputs.sdk-dir }}
```
