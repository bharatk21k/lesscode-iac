resource "pingdom_team" "monitor" {
  name = "Monitoring Team"
  member_ids = var.userids
}

resource "pingdom_check" "prod" {
    count          = length(var.url)
    type           = "http"
    encryption     = "true"
    name           = element(concat(var.service_name, [""]), count.index)
    url            = element(concat(var.url, [""]), count.index)
    host           = var.domain
    integrationids = var.integrationids
    teamids        = [
      pingdom_team.monitor.id
    ]
    teamids        = [ pingdom_team.monitor.id ] 
    #userids       = var.userids
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

