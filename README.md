This repo is for add a jvb jitsi instance to a main
jitsi instalation (with docker)


> cp env.example .env

set XMPP_SERVER with the host docker ip 
where the jitsi_main instance is running

example: XMPP_SERVER=192.168.0.10

set JVB_PORT and JVB_TCP_PORT with the ports you want to use
this ports must be different for the main jvb instance (in jitsi_main)

JVB_PORT=20000
JVB_TCP_PORT=4444

> docker-compose up -d
