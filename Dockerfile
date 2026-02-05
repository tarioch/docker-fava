FROM python:3.15.0a5

ENV BEANCOUNT_INPUT_FILE ""
ENV FAVA_OPTIONS "-H 0.0.0.0 -p 5000"

RUN apt update\
    && apt install -y ghostscript bison flex

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Default fava port number
EXPOSE 5000

CMD fava $FAVA_OPTIONS $BEANCOUNT_INPUT_FILE
