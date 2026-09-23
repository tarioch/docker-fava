FROM ghcr.io/astral-sh/uv:0.12.17-python3.14-trixie-slim@sha256:63018e7b676ef735eee4da4f9c2e7b5f5e3851fa023745d78ce91d1a099a35fd

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
    && apt-get install -y --no-install-recommends git openssh-client tini \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock /project/

RUN uv sync --locked --project /project

# Default fava port number
EXPOSE 5000

# fava does not handle SIGTERM as PID 1, tini forwards the stop signal and reaps child processes
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "exec fava $FAVA_OPTIONS $BEANCOUNT_INPUT_FILE"]
