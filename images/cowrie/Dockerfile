FROM python:3.7

LABEL maintainer="Team Stingar <team.stingar@duke.edu>"
LABEL summary="Cowrie HoneyPot container"
LABEL description="Cowrie is a medium interaction SSH and Telnet honeypot designed to log brute force attacks and the shell interaction performed by the attacker."
LABEL authoritative-source-url="https://github.com/CommunityHoneyNetwork/communityhoneynetwork"

ENV DOCKER="yes"
ENV COWRIE_VERS="v2.1.0"

RUN mkdir -p /code /data /etc/cowrie

COPY chn-register.py /code/
COPY entrypoint.sh /code/
COPY config/cowrie.reference.cfg /code/
COPY requirements.txt /code/
COPY config/cowrie.nopubkey.cfg /code/cowrie.reference.cfg

# Add the cowrie user
RUN useradd -m -s /bin/bash cowrie

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       gcc python3-dev libssl-dev git authbind jq libsnappy-dev \
    && pip3 install -r /code/requirements.txt \
    && cd /opt \
    && git clone --branch "${COWRIE_VERS}" http://github.com/cowrie/cowrie \
    && pip3 install -r /opt/cowrie/requirements.txt \
    && pip3 install -r /opt/cowrie/requirements-output.txt
    
RUN cp /opt/cowrie/etc/userdb.example /opt/cowrie/etc/userdb.txt \
    && bash -c "touch /etc/authbind/byport/{1..1024}" \
    && chmod 755 /etc/authbind/byport/* \
    && chown -R cowrie:cowrie /data /etc/cowrie /opt/cowrie \
    && rm -rf /opt/cowrie/.git \
    && apt-get remove -y git gcc python3-dev libssl-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY hpfeeds3.py /opt/cowrie/src/cowrie/output/

RUN chmod +x /code/entrypoint.sh

USER cowrie

ENTRYPOINT ["/code/entrypoint.sh"]