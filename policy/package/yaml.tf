

locals {
    objects = yamldecode(file("${path.module}/_objects.yaml"))
}

output "objects" {
    value = local.objects
}