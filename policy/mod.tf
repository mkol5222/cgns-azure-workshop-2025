module "package" {
  source = "./package"

  cpman_ip = "" //local.cpman_ip
  cpman_admin = var.cpman_admin
  cpman_pass = var.cpman_pass

  providers = {
    checkpoint = checkpoint.cp
  }
}
