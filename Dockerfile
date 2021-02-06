FROM python:3.8.3-alpine3.11 as tester

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

ADD config /app/config
ADD setup.py /app
ADD setup.cfg /app
ADD pytest.ini /app
ADD .coveragerc /app
ADD .isort.cfg /app
ADD pylintrc /app
ADD helloworld /app/helloworld
ADD tests /app/tests
ADD test_requirements.txt /app

RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel
RUN pip install -r test_requirements.txt
RUN pip install -e .

FROM python:3.8.3-alpine3.11 as builder

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

ADD config /app/config
ADD setup.py /app
ADD setup.cfg /app
ADD pytest.ini /app
ADD .coveragerc /app
ADD .isort.cfg /app
ADD pylintrc /app
ADD helloworld /app/helloworld
ADD tests /app/tests

RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel
RUN pip install -e .

FROM python:3.8.3-alpine3.11 as release

RUN mkdir -p /app && \
    adduser -h /app -s /bin/false -DH www

COPY --from=builder /app/venv /app/venv

WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

RUN chown -R www. /app

USER www

EXPOSE 8080

ENV PYTHONUNBUFFERED 1
ENTRYPOINT ["helloworld", "serve"]
