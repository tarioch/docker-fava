FROM python:3.14.7@sha256:e06cc1111ed84189e91866447f562b89faadbfbbb9937cd67e6bf4172cdb45df

ENV BEANCOUNT_INPUT_FILE="" \
    FAVA_OPTIONS="-H 0.0.0.0 -p 5000"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ghostscript tini \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Default fava port number
EXPOSE 5000

# fava does not handle SIGTERM as PID 1, tini forwards the stop signal and reaps child processes
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "exec fava $FAVA_OPTIONS $BEANCOUNT_INPUT_FILE"]
