resource "azurerm_resource_policy_exemption" "exemption" {
  name                 = "${var.policy_category}-${var.use_name}-${var.env}-${var.region}-policy-exemption"
  resource_id          = var.resource_id
  policy_assignment_id = var.policy_assignment_id
  exemption_category   = "Waiver"
}