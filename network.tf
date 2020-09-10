resource "ibm_is_vpc" "iac_test_vpc" {
  name           = "${var.project_name}-${var.environment}-cr8-vpc"
  resource_group = "cdf2e8a9ed0f4511a925617d1cc2c7f5"
  tags           = ["iac-${var.project_name}-${var.environment}-cr8"]
}

resource "ibm_is_subnet" "iac_test_subnet" {
  name                     = "${var.project_name}-${var.environment}-cr8-subnet"
  resource_group           = "cdf2e8a9ed0f4511a925617d1cc2c7f5"
  vpc                      = ibm_is_vpc.iac_test_vpc.id
  zone                     = "us-south-1"
  total_ipv4_address_count = 256
}

resource "ibm_is_floating_ip" "iac_test_floating_ip" {
  name           = "${var.project_name}-${var.environment}-ip-cr8"
  resource_group = "cdf2e8a9ed0f4511a925617d1cc2c7f5"
  target         = ibm_is_instance.iac_test_instance.primary_network_interface.0.id
  tags           = ["iac-${var.project_name}-${var.environment}-cr8"]
}

resource "ibm_is_security_group" "iac_test_security_group" {
  name           = "${var.project_name}-${var.environment}-sg-public-cr8"
  vpc            = ibm_is_vpc.iac_test_vpc.id
  resource_group = "cdf2e8a9ed0f4511a925617d1cc2c7f5"
}

resource "ibm_is_security_group_rule" "iac_test_security_group_rule_all_outbound" {
  group     = ibm_is_security_group.iac_test_security_group.id
  direction = "outbound"
}

resource "ibm_is_security_group_rule" "iac_test_security_group_rule_tcp_http" {
  group     = ibm_is_security_group.iac_test_security_group.id
  direction = "inbound"
  tcp {
    port_min = var.port
    port_max = var.port
  }
}
resource "ibm_is_security_group_rule" "iac_test_security_group_rule_tcp_ssh" {
  group     = ibm_is_security_group.iac_test_security_group.id
  direction = "inbound"
  tcp {
    port_min = 22
    port_max = 22
  }
}

