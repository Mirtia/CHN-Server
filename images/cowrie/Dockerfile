ARG COWRIE_VERSION=latest

FROM stingar/cowrie:${COWRIE_VERSION}

COPY chn-register.py /code/
COPY entrypoint.sh /code/

USER root

RUN chmod +x /code/entrypoint.sh

USER cowrie
