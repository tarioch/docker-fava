# docker-fava

[![Docker Image CI](https://github.com/tarioch/docker-fava/actions/workflows/dockerimage.yml/badge.svg?branch=master)](https://github.com/tarioch/docker-fava/actions/workflows/dockerimage.yml)

Docker image with [fava](https://github.com/beancount/fava) and the tools around it that are used with
[Beancount](https://beancount.github.io/):

- [smart-importer](https://github.com/beancount/smart_importer)
- [tariochbctools](https://github.com/tarioch/beancounttools)
- [beancount-reds-plugins](https://github.com/redstreet/beancount_reds_plugins)
- [fava-dashboards](https://github.com/andreasgerstmayr/fava-dashboards)
- [beanprice](https://github.com/beancount/beanprice)

The image is published as [`tarioch/fava`](https://hub.docker.com/r/tarioch/fava) on Docker Hub.

## Usage

```bash
docker run --rm -p 5000:5000 \
  -v /path/to/ledger:/ledger \
  -e BEANCOUNT_INPUT_FILE=/ledger/main.beancount \
  tarioch/fava
```

Fava is then available on http://localhost:5000.

| Environment variable | Default | Meaning |
|---|---|---|
| `BEANCOUNT_INPUT_FILE` | (empty) | the beancount file, or several files separated by a space |
| `FAVA_OPTIONS` | `-H 0.0.0.0 -p 5000` | options passed to `fava` |

Any other command can be run in the image by overriding the command, e.g. `docker run --rm tarioch/fava bean-check --version`.

## Tags

| Tag | Content |
|---|---|
| `latest` | the latest build of `master` (or of a release) |
| `<timestamp><commit>` | snapshot of a build of `master`, e.g. `20260919001953227b518` |
| `x.y.z` | release |

See [CONTRIBUTING.md](CONTRIBUTING.md) for how the image is built and released.
