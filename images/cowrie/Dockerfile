ARG COWRIE_VERSION=latest
ARG ARCH=""

FROM stingar/cowrie${ARCH}:${COWRIE_VERSION}

COPY chn-register.py /code/
COPY entrypoint.sh /code/

USER root

RUN chmod +x /code/entrypoint.sh

USER cowrie
