provider "aws" {
  region = "us-east-1"

}

module "webserver_cluster" {

  source                 = "../../../../modules/services/webserver-cluster"
  db_remote_state_bucket = "terra-forma-borja-3001"
  db_remote_state_key    = "integ/data-stores/mysql/terraform.tfstate"

}
terraform {
  backend "s3" {
    bucket         = "terra-forma-borja-3001"
    key            = "integ/services/webserver-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terra-forma-borja-3031-locks"
    encrypt        = true
  }

}
output "alb_dns_name" {

  value = module.webserver_cluster.dns-name
}
resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 12345
  to_port           = 12345
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.webserver_cluster.sg_id
}
