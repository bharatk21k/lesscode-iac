resource "pingdom_check" "test" {
    count          = length(var.url)
    type           = "http"
    encryption     = "true"
    name           = element(concat(var.service_name, [""]), count.index)
    url            = element(concat(var.url, [""]), count.index)
    host           = var.domain
    shouldcontain  = var.status
    integrationids = var.integrationids
    teamids        = [
      pingdom_team.monitor.id,
      pingdom_team.infra.id
    ]
    userids        = var.userids
    tags           = var.ecs_cluster_name
    resolution     = 1
    sendnotificationwhendown = 1
    responsetime_threshold   = 5000
    notifywhenbackup         = "true"
    requestheaders = {
      "User-Agent" =  "Pingdom.com_bot_version_1.4_(http://www.pingdom.com/)"
     }    
}

