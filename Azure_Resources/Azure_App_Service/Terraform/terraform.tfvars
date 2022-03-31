asp_name = "tf-pipeline-asp-qwerd"
app_name = "tf-pipeline-app-qwerd"
asp_kind = "Linux"
asp_reserved = true
asp_sku = {
   tier = "Free",
   size = "F1",
   capacity = 1
  }
location = "westeurope"
resourceGroup = "pipeline-rg"
tags = {
  "env" = "test",
  "createdby" = "tf-pipeline"
}