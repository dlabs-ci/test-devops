DevOPS Test
======================
The Business of Fashion uses various tests to assess whether a candidate is best suited to the expectations of the role advertised and the offer given.

This test aims to demonstrate your technical skills in practice: that you can deliver a solution which implements a scalable backend architecture, that produces the right results, and that pays attention to the requirement details.

Instructions & Deliverables
---------------------------

1. Fork this repository to your account (https://help.github.com/articles/fork-a-repo/)
1. Read these instructions carefully first before continuing with the practical test
2. Read the Requirements and Conditions of Acceptance
3. Implement solution
    - Develop a solution which demonstrates your skills and strengths
    - You may add/change/modify any files in the project except for `main.go` file.
    - You shouldn't change environment variable configuration in `docker-compose.yml` file (e.g. `environment`, `env_file`).
    - Docker entrypoint must be set to `entrypoint.sh`
4. Describe how you can build a better "Product" for this coding task in SOLUTION.md and include your estimates
5. Create a pull request to origin repository when you are satisfied with your solution (https://help.github.com/articles/about-pull-requests/) 


Other Notes
-----------

- Please remember to demonstrate your skills and how you would  normally approach
development tasks regardless of this smaller task size.
- I must ask that you time yourself so that you balance Quality and Delivery. I will not prescribe a
deadline of X hours, instead, I would like you estimate the task, complete the task, and measure your elapsed time. Please submit your estimate and actual time with your code solution.


Requirements
================================

`testserver` is a simple HTTP server written in Go with a single exposed endpoint at `/` which returns some info about user and server. We expect you to thoroughly analyse this project and properly set it up to return response as described in Example Output section.

### 1. Initial setup
After you setup your project as described in Technical Setup section you will notice that running `curl -i http://testserver.lan` will return 502 response. You need to investigate and resolve this issue first. Describe your approach and solution. How did you pinpoint the problem?

### 2. Nginx as a loadbalancer
We use nginx as a loadbalancer so your task is to set it up best as you can. Please comment your settings and decisions in nginx configuration files. To test loadbalancing you can run `docker-compose up -d --scale testserver=3`. This will spin up three instances of testserver. Inspect the response and make sure that hostname changes with requests. You may need to restart nginx in order to start routing to new hosts. Why? How would you solve this?

### 3. Environment configuration
Environment variables required by testserver are located in `.env` file. Consume `.env` file in `entrypoint.sh` and make environment variables available to testserver. If this is done right you will see `project` in response set to `testserver`.

### 4. Graceful shutdown
Testserver supports graceful shutdown via SIGUSR1 signal. Make it work with docker-compose (stop, restart). 

### 5. Docker images
#### 5.1 Optimization
On large project docker images can become quite huge and even bigger than 1GB.
Why do you think it is important to optimize images and keep them small?
Image for testserver is small (~70MB) but with some minimal changes you can bring it down under 15MB which is nice right? Do you know how to do it?

#### 5.2 Organization (optional/bonus)
Imagine that you have an app with following requirements:
- PHP
- Ruby (sidekiq which calls PHP scripts)
- NodeJS (for building frontend assets)

How would you split Dockerfiles and how would you setup your image build pipeline?

### 6. TLS
For this task you will need to generate self signed certificates. You can use `openssl` or `cfssl` for this. All certificates should be stored in `./crt` dir which is mounted by Docker. All certificates should be issued by the same CA. Put code for certificate generation in `certs` target in Makefile.

#### 6.1 SSL termination
Setup nginx to handle SSL termination.

Flow: user -(https)-> nginx

#### 6.2 Secure testserver and provide authentication with TLS
Testserver supports TLS and authenticates user based on certificate CN. TLS is enabled by providing certificates via CLI flags. Testserver should use a certificate issued specifically for server. Nginx should use a seperate client certificate with CN set to your email. If this is done right you will see `email` in response set to your email.

Flow: nginx ---> testserver

Technical Setup
===============
### Docker on Linux:
Add following entry to `/etc/hosts`:
```bash
172.80.1.1 testserver.lan
```
Run Makefile:
```bash
make init-linux
```

### Docker for Mac:
Add following entry to `/etc/hosts`:
```bash
127.0.0.1 testserver.lan
```
Run Makefile:
```bash
make init-mac
```
If you have any issues with port collisions you can change ports in `.env` file which is generated by `Makefile`.

### Exposed ports:
- 80 for HTTP
- 443 for HTTPS

Example Output
--------------
This is an example output of complete solution:
```bash
curl -ik https://testserver.lan

HTTP/1.1 200 OK
Server: nginx/1.13.3
Date: Thu, 17 Aug 2017 19:38:14 GMT
Content-Length: 117
Connection: keep-alive
Content-Type: application/json
```
```json
{
    "hostname": "a9900ff3695a",
    "name": "Your Name",
    "email": "your.name@example.com",
    "project": "testserver",
    "ip": "172.80.1.2"
}
``` 
