# Background
Lesscode is a playground for me to explore tools and techniques for writing less code. 
Click here to visit my other work under [lesscode](https://github.com/van001).

# Overview

The goal of this project is to provide modules (terraform) to create/ destroy a simple microservice and serverless infrastructure stack. 
It does not create/destroy any messaging & data stack (yet). Feel free to clone and add modules to do that.

It is an opinionated framework/stack (but generic enough), which helps to automate the creation and destruction of a microservice/ serverless infrastructure for quick
build and deployment of APIs, UIs and MQ(Message Q) services. The architecture fully supports multi-region deployment using route53 geo routing.

If you are not writing a **monolithic** application then you are either writing a service oriented **(SOA)** or a **microservice** or a **serverless** application. Wouldn't it be nice if you could create/destroy those infrastructures on demand? That's the motivation behind this project.

The **microservice** stack contains :

- **AWS Fargate** for orchestration and management of containers. It assumes that you are doing container (docker) based deployment.
- **Auto-scaling policies** for service scaling.
- **AWS ALB (Application load balancer)** for availibility, routing (via path) and service discovery (using DNS and path). Again, assumption here is that you are building a small to mid-size applications with 10s-100s of servers.
- **Route53** and **Cloudfront** for external discovery and CDN routing.
- **VPC**, **ACM**, **SecurityGroups**, **IAM** for isolation and security.
- **Cloudwatch** for observability - logs, metrics and dashboards.
- **ECS** (Elastic container service) for container storage.
- **S3** for object/ blob store.
- **DynamoDB**(coming soon) for data store (single table design).
- **SNS/SQS**(coming soon) for asynchronous communication. Every service gets a topic.
- **KMS** for application security & key management.
- **Configuration** management done via environment variables. Same artifacts can be deployed with a new configuration.


![IAC](/assets/architecture.png)

This project is a part of bigger initiative on how to build a brand new micro services with [contract 1st development](https://github.com/van001/lesscode-architecture).

Currently it only supports building a microservice in AWS.

# Usage

### For microservice creation & deployment

### Pre-requesite
- Create an IAM (service) role with the following permissions :
![permission.png](/assets/permission.png)
- Install [terraform](https://www.terraform.io/downloads.html) CLI. Use the access/ secret key to run terraform.
```
export AWS_ACCESS_KEY_ID= <key>
export AWS_SECRET_ACCESS_KEY= <secret>
```

#### 1. Create an empty microservice cluster.

If you want to create an empty microservice stack and deploy API, MQ services (later), create the following script files. 
We recommend creating a separte directory for each environmnet/ cluster. Make sure to prefix cluster name with 'env' for readibility sake. Have 
default cluster for each envs like dev, stage, prod etc.


**main.tf**
```
# Create an empty Fargate cluster
module "cluster" {
    source = "github.com/van001/lciac//microservice/aws/cluster"
    
    # domain name like dev.example.com
    domain = var.domain
    
    # aws region, in which this cluster will be created. e.g. "us-west-1"
    region = var.region

    # development environment .e.g dev, stage, prod etc
    env = var.env

    # cluster name
    ecs_cluster_name = var.ecs_cluster_name
}

# Then map the routing via Route 53/ Cloudfront. This is optional, but uisng CF as CDN improves your APIs overall latency.
module "routing" {
    source = "github.com/van001/lciac//microservice/aws/routing"
    
    # domain name like dev.example.com
    domain = var.domain
    
    # zone id of the hosted domain in route 53
    zoneid = var.zoneid

    # development environment .e.g dev, stage, prod etc
    env = var.env

    # Alb name
    alb_dns_name = module.ms-cluster.alb_dns_name

}
```

**vars.tf**
```
variable "region" {
    type = string
    default = "us-east-1"
}

variable "env" {
    type = string
    default = "dev"
}


variable "zoneid" {
    type = string
    default = "Z3DW7T7D7J20Z4"
}

variable "domain" {
    type =  string 
    default = "dev.vethospital.io"
}

variable "ecs_cluster_name" {
    type = string
    default = "main-dev-us-west-1"
}
```

**outputs.tf**
```
output "alb_dns_name" {
  value = "${module.ms-cluster.alb_dns_name}"
}
```
To run :
```
terraform init
terraform apply
```
Sample output :
```
Outputs:

alb_dns_name = dev-load-balancer-1628960179.us-east-1.elb.amazonaws.com
aws_alb_listener_arn = arn:aws:elasticloadbalancing:us-east-1:284832936816:listener/app/dev-load-balancer/825d0ad0d22536a5/880ebd191c8409a5
aws_security_group_lb_id = sg-044677092282bc549
ecs_cluster_arn = arn:aws:ecs:us-east-1:284832936816:cluster/dev-cluster
subnets_privates_ids = [
  [
    "subnet-0e0eb669084e83414",
    "subnet-0da006150bd80e07b",
  ],
]
vpc_id = vpc-06fa1b6c91ef0f332
```

#### 2. Create services

For each service, create a new directory under each cluster/env name that you created above. 
For each service, create the following scripts : 

**main.tf**

```
module "vetoffice-api" {
  
    source = "github.com/van001/lciac//microservice/aws/service/api"

    # aws region, in whihc this cluster will be created. e.g. "us-west-1"
    region = var.region

    # development environment .e.g dev, stage, prod etc
    env = var.env

    # cluster name
    ecs_cluster_name = var.ecs_cluster_name

    # service name 
    name = var.service_name

    # TLS port
    tls_port = var.tls_port

    # Service Image
    service_image = var.service_image

    # Service port
    service_port = var.service_port

    # Min Service Count (Auto scaling)
    service_count_min = var.service_count_min

    # Max Service Count (Auto scaling)
    service_count_max = var.service_count_max

    # Path
    path = var.path

    # Healtcheck Path
    health_check_path = var.health_check_path

    # Fargate CPU
    fargate_cpu = var.fargate_cpu

    # Fargate Memorty
    fargate_memory = var.fargate_memory

}
```

**vars.tf**

```
variable "region" {
    type = string
    default = "us-east-1"
}

variable "env" {
    type = string
    default = "dev"
}

variable "ecs_cluster_name" {
    type = string
    default = "dev"
}

variable "service_name" {
    type = string
    default = "api-vethospital"
}

variable "service_image" {
    type = string
    default = "284832936816.dkr.ecr.us-east-1.amazonaws.com/vethospital-api:1cc4f28e15fede7647db2ce5177f93fe1ef32e49"
}

variable "tls_port" {
  description = "LB port"
  default     = 443
}

variable "service_port" {
    type = string
    default = "8090"
}

variable "service_count_min" {
    type = string
    default = "2"
}

variable "service_count_max" {
    type = string
    default = "6"
}

variable "fargate_cpu" {
    type = string
    default = "1024"
}

variable "fargate_memory" {
    type = string
    default = "2048"
}

variable "path" {
    type = string
    default = "/api/v1"
}

variable "health_check_path" {
    type = string
    default = "/api/v1/tennants/123"
}
```

**outputs.tf**

```
output "ecs_task_arn" {
    value = module.vetoffice-api.ecs_task.arn
}

output "ecs_service_arn" {
    value = module.vetoffice-api.ecs_service.id
}
```

When the service is launched, containers get the following env variables
```
ECS_CLUSTER_NAME
```

#### All together :

| Dir                           | Notes                                        |
|-------------------------------|----------------------------------------------|
| ![dir](/assets/code-org.png)  | - Separate directory for clusters & services.|


|  Cluster                        |
|---------------------------------|
| ![cluster](/assets/cluster.png) |


| Service                             | Tasks                     | Autoscaling                             |
|-------------------------------------|---------------------------|-----------------------------------------|
| ![service.png](s/assets/ervice.png) | ![task](/assets/task.png) | ![autoscaling](/assets/autoscaling.png) | 


| Root                      | API                             | Dashboard                               |
|---------------------------|---------------------------------|-----------------------------------------|
| ![root](/assets/root.png) | ![tennant](/assets/tennant.png) | ![dashboard.png](/assets/dashboard.png) |





# Modules
## Microservice
Contain all the terraform scripts to create a complete microservice environment from scratch. 
### In AWS

#### [cert](https://github.com/van001/lciac/tree/master/microservice/aws/cert)
Cert module helps create a valid ACM. If you are going to use 'route' module, which uses cloudfront to route requests to ALB, you will have to create certificate in "US_EAST_1" region only.

1. Creates an ACM in the specified region
2. Updates Route53 entries to auto verify the created cert.

#### [cluster](https://github.com/van001/lciac/tree/master/microservice/aws/cluster)
Cluster module create a brand new fargate cluster.

1. Creates an empty fargate cluster. No task or service definition yet. 
2. Creates and attach an application load balancer. 
3. Installs sepcified SNI certificate.

#### [routing](https://github.com/van001/lciac/tree/master/microservice/aws/routing)
Routing module maps the domain name via Route53 to CF/ ALB.

1. Map route 53 mapping to cluster.

#### [service/api](https://github.com/van001/lciac/tree/master/microservice/aws/service/api)
Service module helps you create a brand new service. Service can be API or MQ (Message Q listeners).

1. Creates a new service.
2. Creates a task definition in the specified fargate cluster.
3. Create a ECS repository for the specified service.


