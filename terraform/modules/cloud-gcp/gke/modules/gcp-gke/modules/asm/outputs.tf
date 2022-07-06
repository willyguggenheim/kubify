

output "revision_name" {
  value       = local.revision_name
  description = "The name of the installed managed ASM revision."
}

output "wait" {
  value       = module.cpr.wait
  description = "An output to use when depending on the ASM installation finishing."
}
