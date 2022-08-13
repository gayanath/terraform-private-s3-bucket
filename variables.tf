variable "bucket_name" {
  type = string
}

variable "default_encryption_enabled" {
  type    = bool
  default = true
}

variable "versioning_enabled" {
  type    = bool
  default = false
}

variable "lifecycle_enabled" {
  type    = bool
  default = false
}
