resource "pingdom_check" "dev" {
    type = "http"
    encryption = "true"
    port = var.tls_port
    name = var.service_name
    host = var.domain
    url  = var.url
    integrationids = var.integrationids
    teamids = var.teamids
    userids = var.userids
    shouldcontain = var.status
    tags = var.ecs_cluster_name
    requestheaders = {
      "User-Agent" =  "Pingdom.com_bot_version_1.4_(http://www.pingdom.com/)"
     }
    resolution = 1
    sendnotificationwhendown = 1
    responsetime_threshold = 5000
    notifywhenbackup = "true"
}
