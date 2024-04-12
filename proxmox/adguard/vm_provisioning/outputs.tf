output "uploaded_image_file_name" {
  value = proxmox_virtual_environment_download_file.ubuntu-qcow2-img.file_name
}
output "ubuntu_cloud_init_user_conf_file_name" {
  value = proxmox_virtual_environment_file.ubuntu-cloud-init-user-config.file_name
}
output "ubuntu_cloud_init_vendor_conf_file_name" {
  value = proxmox_virtual_environment_file.ubuntu-cloud-init-vendor-config.file_name
}

output "worker_vm_info" {
  value = module.worker
}