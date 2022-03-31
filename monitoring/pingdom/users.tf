resource "pingdom_team" "monitor" {
  name = "Monitoring Team"
  member_ids = var.userids
}

resource "pingdom_team" "infra" {
  name = "Infra Engineering"
  member_ids = [
    pingdom_contact.infra_contact.id,
    pingdom_contact.dev_contact.id
  ]
}

resource "pingdom_contact" "infra_contact" {
  name = "Sudhakar Chundu"

  sms_notification {
    number   = "9966699668"
    severity = "HIGH"
  }

  sms_notification {
    number       = "9966699668"
    country_code = "91"
    severity     = "LOW"
    provider     = "esendex"
  }

  email_notification {
    address  = "sudhakarbabu.c@albertinvent.com"
    severity = "LOW"
  }
}

resource "pingdom_contact" "dev_contact" {
  name = "Neelesh Vaikhery"

  sms_notification {
    number   = "8977909668"
    severity = "HIGH"
  }

  sms_notification {
    number = "8977909668"
    country_code = "91"
    severity = "LOW"
    provider = "esendex"
  }
  
  email_notification {
    address = "neelesh.vaikhary@albertinvent.com"
    severity = "LOW"
  }
}
