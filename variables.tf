variable "instance_names" {
  type = list(string)
  default = ["app server", "web server", "reverse proxy server"]
}

variable "security_groups" {
  type = list(object({
    name        = string
    description = string
    ports       = list(number)
  }))
  default = [
    {
      name        = "allow-http-connection"
      description = "Security Group 1 description"
      ports       = [8082, 8082]
    },
    {
      name        = "allow-ssh-connection"
      description = "Security Group 2 description"
      ports       = [22, 22]
    }
  ]
}