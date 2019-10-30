module "status_api" {
  source = "./modules/service/api"

  namespace = "status-api"

  container_image = "vad1mo/hello-world-rest"
  container_port  = "5050"

  namespace_id = "${aws_service_discovery_private_dns_namespace.namespace.id}"

  cluster_id = "${aws_ecs_cluster.requests_api.name}"

  vpc_id = "${local.vpc_id}"

  security_group_ids = [
    "${aws_security_group.service_egress_security_group.id}",
    "${aws_security_group.service_lb_ingress_security_group.id}",
  ]

  subnets               = ["${local.private_subnets}"]
  nginx_container_port  = "9000"
  nginx_container_image = "wellcome/nginx_api-gw:77d1ba9b060a184097a26bc685735be343b1a754"

  env_vars = {
    app_base_url      = "https://api.wellcomecollection.org/item-status/v1/storage/v1/bags"
    context_url       = "https://api.wellcomecollection.org/item-status/v1/context.json"
    metrics_namespace = "status_api"
  }

  env_vars_length = 1

  secret_env_vars = {
    sierra_auth_user = "catalogue/requests/sierra_auth_user"
    sierra_auth_pass = "catalogue/requests/sierra_auth_pass"
  }

  secret_env_vars_length = 2

  lb_arn             = "${data.terraform_remote_state.catalogue_api.catalogue_api_nlb_arn}"
  listener_port      = "65524"
  cpu                = 2048
  memory             = 4096
  sidecar_cpu        = 1024
  sidecar_memory     = 2048
  app_cpu            = 1024
  app_memory         = 2048
  task_desired_count = "1"
}


