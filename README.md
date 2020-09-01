# Overview


# module : microservice
Contain all the terraform scripts to create a complete microservice environment.
## In AWS
### Cluster
1. Create an empty fargate cluster. 
2. Create and attach an application load balancer. 
3. Create and install a SNI cerficate for the specified domain.

### routing
1. Map route 53 mapping to cluster.

### service
1. Create a new service.
2. Create a task definition in the secified argate cluster

