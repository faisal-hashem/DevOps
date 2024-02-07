output "policy_exemption_id" {
  value = azurerm_resource_policy_exemption.sql_exemption.id
  description = "The ID of the policy exemption."
}