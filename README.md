# Overview
The goal of this repo is to provide terraform modules to create microservice and serverless infrastructure. 
It is an opinionated framework that helps user create a simple/ single region (multiple AZ) infrastructure for quick
build and deployment of apis, UIs and Q services.

# Usage

# Under the hood
## module : microservice
Contain all the terraform scripts to create a complete microservice environment.
### In AWS

#### cert
Cert module helps create a valid ACM. If you are going to use 'Route' module, which used cloufront to route requests voa Route53 to ALB, you will habe to create certificate in "US_EAST_1" region only.

1. It create ACM in the specified region
2. It uodate Route53 entries to auto verify the created cert.

#### cluster
Cluster module create a brand new fargate cluster.

1. Create an empty fargate cluster. 
2. Create and attach an application load balancer. 
3. Create and install a SNI cerficate for the specified domain.

#### routing
Routing module maps the domain name via Route53 to CF/ ALB.

1. Map route 53 mapping to cluster.

#### service
Service module helps you create a brand new service. Service can be API or MQ (Message Q listeners).

1. Create a new service.
2. Create a task definition in the secified argate cluster

