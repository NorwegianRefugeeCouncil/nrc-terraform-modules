variable "resource_group_name"{
    description = "Name of the resurce group where acr is to be deployed"
    type = string
}
variable "acr_name"{
     description = "Name of the acr is to be deployed"
    type = string
}
}
variable "location"{
     description = "Location in Azure"
    type = string
}
}