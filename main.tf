data "aws_vpc" "main" {
  default = true
}

data "aws_subnet" "primary" {
  vpc_id               = "${data.aws_vpc.main.id}"
  availability_zone_id = "euw3-az1"
}

variable "cidr" {
  type = list(string)
}

module "webserver" {
  source = "./webserver"

  vpc_id    = "${data.aws_vpc.main.id}"
  subnet_id = "${data.aws_subnet.primary.id}"
  cidr      = var.cidr
}
