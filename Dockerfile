FROM python:3.13.5

ENV BEANCOUNT_INPUT_FILE ""
ENV FAVA_OPTIONS "-H 0.0.0.0 -p 5000"

RUN apt update\
    && apt install -y ghostscript libgl1-mesa-glx

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Default fava port number
EXPOSE 5000

CMD fava $FAVA_OPTIONS $BEANCOUNT_INPUT_FILE
