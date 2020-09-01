# 1st create a new fargate cluster
module "ms-cluster" {
    source = "../../modules/microservice/aws/cluster"
    
    # domain name like dev.example.com
    domain = "dev.vethospital.io"
    
    # zone id of the hosted domain in route 53
    zoneid = "Z3DW7T7D7J20Z4"

    # aws region, in whihc this cluster will be created. e.g. "us-west-1"
    aws_region = "us-west-1"

    # development environment .e.g dev, stage, prod etc
    env = "dev"

    # cluster name
    ecs_cluster_name = "main-dev-us-west-1"
}

# Then map the routing via route 53
module "routing" {
    source = "../../modules/microservice/aws/routing"
    
    # domain name like dev.example.com
    domain = "dev.vethospital.io"
    
    # zone id of the hosted domain in route 53
    zoneid = "Z3DW7T7D7J20Z4"

    # aws region, in whihc this cluster will be created. e.g. "us-west-1"
    aws_region = "us-west-1"

    # Alb name
    alb_dns_name = module.ms-cluster.alb_dns_name

}