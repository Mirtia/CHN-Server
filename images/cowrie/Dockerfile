FROM python:3.10

LABEL maintainer="Team Stingar <team.stingar@duke.edu>"
LABEL summary="Cowrie HoneyPot container"
LABEL description="Cowrie is a medium interaction SSH and Telnet honeypot designed to log brute force attacks and the shell interaction performed by the attacker."
LABEL authoritative-source-url="https://github.com/CommunityHoneyNetwork/communityhoneynetwork"

RUN mkdir -p /code /data /etc/cowrie

COPY chn-register.py /code/
COPY entrypoint.sh /code/
COPY requirements.txt /code/
COPY config/cowrie.nopubkey.cfg /code/cowrie.reference.cfg

# Add the cowrie user
RUN useradd -m -s /bin/bash cowrie

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       gcc python3-dev libssl-dev git authbind jq libsnappy-dev \
    # Requirements are not strict here
    && pip3 install -r /code/requirements.txt \
    && cd /opt \
    # Clone the latest cowrie
    && git clone http://github.com/cowrie/cowrie \
    # Cowrie
    # Install plugin and basic requirements for production
    && pip3 install -r /opt/cowrie/requirements.txt \
    && pip3 install -r /opt/cowrie/requirements-output.txt
    
RUN cp /opt/cowrie/etc/userdb.example /opt/cowrie/etc/userdb.txt \
    # Bind ports
    && bash -c "touch /etc/authbind/byport/{1..1024}" \
    && chmod 755 /etc/authbind/byport/* \
    && chown -R cowrie:cowrie /data /etc/cowrie /opt/cowrie
    # Remove .git
RUN rm -rf /opt/cowrie/.git \
    && apt-get remove -y git gcc python3-dev libssl-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Not sure if this is needed here, there are little differences
# To be removed
# COPY hpfeeds3.py /opt/cowrie/src/cowrie/output/

RUN chmod +x /code/entrypoint.sh

USER cowrie

ENTRYPOINT ["/code/entrypoint.sh"]