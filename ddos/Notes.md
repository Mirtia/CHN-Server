# Setting up a DDoS attack

## TODO
- [x] Set up a victim server with nginx on a different network
- [x] Constraints on the victim server (Ended up creating different types of services)
- [ ] Evaluation metrics for inaccessibility
  - [ ] Scenario: I am another service in the custom network and I want to access the victim's endpoint. How would the victim respond when overloaded with requests?
- [x] See if it is indeed valid to test that on a Docker network -> There are people that have done it, even on the same network, but I haven't looked thorougly.
- [/] Setup tools for monitoring the traffic and also log it (Found the tools but did not set them up)
- [ ] See botnet options
- [ ] Review default configurations for Cowrie (potentially remove RSA options for simplicity)
- [ ] Considerations on the hardware constraints of the botnet actors
- [ ] Suggestions here...

## Reverse-proxy (reverse-proxy)

In order to create a more realistic environment, we create two subnetworks, one for the victim (victim-network) and one for the botnet (chn-network). To redirect network from one network to the other, we configure another container that plays the role of a reverse-proxy (passthrough) that gets the traffic to the victim service.

Create network `docker network create victim-network` before docker compose on the reverse-proxy.

## Types of Services

### Nginx with Limited Resources Serving a Static Webpage (static)
- Simple nginx configuration with reduced buffer sizes and a limited number of worker processes to simulate a constrained server environment.

### Flask App with Gunicorn (dynamic)
- Basic Flask app for serving dynamic content, deployed with Gunicorn and configured to use a restricted number of workers (e.g., 1 to 4).

### Baseline Flask App (baseline)
- Basic Flask app serving dynamic content without Gunicorn or reverse proxy integration, representing an unoptimized setup.

## Tools to Perform a DDoS/Stress Test

## Simple curl script
Just a dummy script to imitate a DDoS.
```sh
for i in {1..100}; do
    (
        while true; do
            curl -s http://0.0.0.0:5000/ > /dev/null
        done
    ) &
done
```

### hping3
**Description:** A command-line oriented TCP/IP packet assembler and analyzer, useful for simulating various types of attacks by crafting and flooding packets.

**Example:**
Install using your package manager:
```sh
sudo apt install hping3
```

Command to simulate a SYN flood:
```sh
sudo hping3 -S -d 10000 172.19.0.2 -k --rand-source --flood -p 5000
```
- `-S`: Sends SYN packets.
- `-d 10000`: Packet size (10,000 bytes).
- `172.19.0.2`: Target IP address.
- `-k`: Keeps the connection alive.
- `--rand-source`: Randomizes the source IP address (simulates a distributed attack).
- `--flood`: Sends packets as quickly as possible.
- `-p 5000`: Target port.

### wrk
**Description:** A modern HTTP benchmarking tool capable of generating high loads. Useful for testing endpoint response times under stress.

**Example:**
Install using your package manager:
```sh
sudo apt install wrk
```

Command to simulate traffic:
```sh
wrk -t40 -c500 -d300s http://localhost:5000
```
- `-t40`: Number of threads.
- `-c500`: Number of concurrent connections.
- `-d300s`: Duration of the test (300 seconds).
- `http://localhost:5000`: Target endpoint.

### Apache Benchmark (ab)
**Description:** A simple tool for benchmarking HTTP requests, particularly useful for testing server concurrency and handling capacity.

**Example:**
Install using your package manager:
```sh
sudo apt install apache2-utils
```

Command for benchmarking:
```sh
ab -l -n 1000000 -c 1000 -k http://0.0.0.0:5000/
```
- `-l`: Do not exit on socket errors.
- `-n 1000000`: Total number of requests to perform.
- `-c 1000`: Number of concurrent requests.
- `-k`: Enable HTTP Keep-Alive.
- `http://0.0.0.0:5000/`: Target URL.

### Slowloris
**Description:** A tool for performing layer 7 (application layer) attacks by opening many simultaneous connections and keeping them alive, effectively exhausting the target server’s resources.

**Usage:**
Install using Python pip:
```sh
pip install slowloris
```

Command for launching the attack:
```sh
slowloris 172.19.0.2 -p 5000 -s 500
```
- `172.19.0.2`: Target IP address.
- `-p 5000`: Target port.
- `-s 500`: Number of simultaneous connections.

## Observations

- I had to run multiple `hping3` or combinations of `hping3` with `ab` to make the `dynamic` version potentially slower, yet it was still available after a while.
- Keep-alive connections seem to be more effective (makes sense).
- Needs more experimentation.