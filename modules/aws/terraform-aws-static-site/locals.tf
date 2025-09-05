locals {
  metric_configuration = var.enable_dashboard == true ? concat([{ name = "EntireBucket" }], var.metric_configuration) : var.metric_configuration

}
