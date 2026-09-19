# Contributing

`docker-fava` builds the Docker image [`tarioch/fava`](https://hub.docker.com/r/tarioch/fava): fava together with
smart-importer, tariochbctools and a few other Beancount tools, see the [README](README.md).

## Layout

| Path | Content |
|---|---|
| `Dockerfile` | the image, based on the official `python` image |
| `requirements.txt` | the python packages that are installed, all with a pinned version |
| `.github/workflows/dockerimage.yml` | lint, build, smoke test and publishing |

## Checks

CI runs the same commands, all of them have to pass:

```bash
uvx pre-commit run --all-files   # file hygiene, hadolint (Dockerfile), zizmor (workflows)
docker build -t fava:ci .
```

Things that catch people out:

- `pre-commit run --all-files` only looks at files tracked by git. `git add` new files before running it, otherwise
  they are not checked (and CI then fails on them).
- The hadolint hook runs in Docker (`hadolint-docker`), it needs a working Docker daemon.
- The CI smoke test starts the image with a small ledger, checks that fava answers and that `docker stop` does not run
  into the kill timeout. Try the same locally:

  ```bash
  docker run --rm -p 5000:5000 -v /path/to/ledger:/ledger -e BEANCOUNT_INPUT_FILE=/ledger/main.beancount fava:ci
  ```

## Dockerfile

- Fava runs behind `tini` (the entrypoint). Without an init process fava is PID 1 and ignores SIGTERM, so the container
  is only stopped by the kill timeout (30 seconds in a Kubernetes pod).
- The base image is pinned with a digest (`python:<version>@sha256:…`), Dependabot updates version and digest together.
- Packages installed with apt: keep `--no-install-recommends` and remove `/var/lib/apt/lists` in the same layer.
  Versions are not pinned (hadolint `DL3008` is ignored in `.hadolint.yaml`), they come from the base image release.

## Dependencies

- Every package in `requirements.txt` has a pinned version and comes from PyPI. Do not install from git branches, the
  build is then not reproducible and Dependabot cannot update it.
- Only direct dependencies are listed, their dependencies are resolved when the image is built.
- Dependabot (`.github/dependabot.yml`) opens grouped PRs for minor and patch updates of the python packages and the
  base image weekly and for GitHub Actions monthly. Major updates come as separate PRs. New releases wait 7 days
  (cooldown), security updates do not.

## Git and pull requests

- Branch off `master`, named `feature/…`, `bugfix/…` or `chore/…` (snake_case after the prefix). The prefix labels the PR
  (`.github/pr-labeler.yml`), and the label decides the category in the release notes (`.github/release-drafter.yml`).
- Commit subjects are imperative and start with a capital letter ("Install fava-dashboards and beanprice from PyPI"),
  the body explains why.
- Changes go through pull requests into `master` and are merged with a merge commit.

## CI and releases

`.github/workflows/dockerimage.yml` runs `lint` and `build` for every pull request and for pushes to `master` and to
version tags. Workflows use the least permissions they need, and every action is pinned to a commit SHA (Dependabot keeps
the pins current, zizmor fails for unpinned actions or broad permissions).

- The `build` job builds the image once, runs the smoke test against it and, for pushes only, pushes exactly that image.
  Pull requests never log in to Docker Hub.
- Every push to `master` publishes `latest` and a snapshot tag (`<timestamp><commit>`).
- Release notes are drafted by release-drafter. Publishing the draft creates the tag `vX.Y.Z`, which publishes the image
  as `X.Y.Z` (and `latest`).
- Publishing needs the repository secrets `DOCKER_USERNAME` and `DOCKER_PASSWORD` (Docker Hub has no trusted
  publishing, use an access token as the password).
- The publishing steps only run for pushes, so they cannot be tested in a pull request. Check the `Build` job of the
  first run after changing them.
