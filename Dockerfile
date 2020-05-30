FROM python:3.8.3-alpine3.11

WORKDIR /app

COPY . /app

RUN apk add --no-cache gcc musl-dev

RUN pip install --upgrade pip setuptools wheel
RUN pip install -e .


RUN adduser -h /app -s /bin/false -DH www \
    && chown -R www. /app

USER www

EXPOSE 8080

ENV PYTHONUNBUFFERED 1
ENTRYPOINT ["helloworld", "serve"]
