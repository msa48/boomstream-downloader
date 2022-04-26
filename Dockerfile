# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.10.4-alpine as base

FROM base as build

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo

WORKDIR /app
COPY requirements.txt .

RUN python -m pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt

FROM base

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY --from=build /app/wheels /wheels
COPY --from=build /app/requirements.txt .

RUN mkdir "output" \
    && apk add ffmpeg \
    && python -m pip install -r requirements.txt --no-cache /wheels/* \
    && rm -rf /wheels

COPY . /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

VOLUME [ "/app/output" ]

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
ENTRYPOINT [ "python", "boomstream.py"]
CMD [ "-h" ]