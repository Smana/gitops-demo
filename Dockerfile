FROM python:3.8.10-alpine3.13 as tester

RUN apk add --no-cache gcc=10.2.1_pre1-r3 musl-dev=1.2.2-r1

WORKDIR /app

COPY config /app/config
COPY setup.py /app
COPY setup.cfg /app
COPY pytest.ini /app
COPY .coveragerc /app
COPY .isort.cfg /app
COPY pylintrc /app
COPY helloworld /app/helloworld
COPY tests /app/tests
COPY test_requirements.txt /app

RUN pip install --upgrade --no-cache-dir pip==21.1.2 setuptools==57.0.0 wheel==0.36.2 && \
    pip install --no-cache-dir -r test_requirements.txt && \
    pip install --no-cache-dir  -e .

FROM python:3.8.10-alpine3.13 as release

RUN apk add --no-cache gcc=10.2.1_pre1-r3 musl-dev=1.2.2-r1

WORKDIR /app

COPY config /app/config
COPY setup.py /app
COPY setup.cfg /app
COPY pytest.ini /app
COPY .coveragerc /app
COPY .isort.cfg /app
COPY pylintrc /app
COPY helloworld /app/helloworld
COPY tests /app/tests

RUN pip install --upgrade --no-cache-dir pip==21.1.2 setuptools==57.0.0 wheel==0.36.2 && \
    pip install --no-cache-dir -e .

RUN mkdir -p /app && \
    adduser -h /app -s /bin/false -DH www && \
    chown -R www. /app

USER www

EXPOSE 8080

ENV PYTHONUNBUFFERED 1
ENTRYPOINT ["helloworld", "serve"]
