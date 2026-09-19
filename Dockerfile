FROM ghcr.io/astral-sh/uv:0.12.17-python3.14-trixie@sha256:9f68650ccb8aee38b7cb6f22cfb6592a1e2e7f05fa3858fdf0bff7fd0acda73d

# The packages are installed into a virtual environment outside of the working directory (/), which stays
# as it was for relative paths in BEANCOUNT_INPUT_FILE.
ENV BEANCOUNT_INPUT_FILE="" \
    FAVA_OPTIONS="-H 0.0.0.0 -p 5000" \
    UV_PROJECT_ENVIRONMENT=/opt/venv \
    VIRTUAL_ENV=/opt/venv \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_NO_CACHE=1 \
    UV_NO_DEV=1 \
    UV_PYTHON_DOWNLOADS=never \
    PATH="/opt/venv/bin:$PATH"

RUN apt-get update \
    && apt-get install -y --no-install-recommends tini \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock /project/

RUN uv sync --locked --project /project

# Default fava port number
EXPOSE 5000

# fava does not handle SIGTERM as PID 1, tini forwards the stop signal and reaps child processes
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "exec fava $FAVA_OPTIONS $BEANCOUNT_INPUT_FILE"]
