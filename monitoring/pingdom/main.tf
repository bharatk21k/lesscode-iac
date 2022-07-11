resource "pingdom_check" "test" {
    count          = length(var.url)
    type           = "http"
    encryption     = "true"
    name           = element(concat(var.service_name, [""]), count.index)
    url            = element(concat(var.url, [""]), count.index)
    host           = var.domain
    custom_message = var.custom_message
    integrationids = var.integrationids
    teamids        = [
      pingdom_team.monitor.id,
      pingdom_team.infra.id
    ]
    userids        = var.userids
    shouldcontain  = var.status
    tags           = var.ecs_cluster_name
    resolution     = 1
    sendnotificationwhendown = 1
    responsetime_threshold   = 5000
    notifywhenbackup         = "true"
    requestheaders = {
      "User-Agent" =  "Pingdom.com_bot_version_1.4_(http://www.pingdom.com/)"
     }    
}

