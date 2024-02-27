output "uploaded_image_file_name" {
  value = proxmox_virtual_environment_download_file.ubuntu_qcow2_img.file_name
}
output "ubuntu_cloud_init_file_name" {
  value = proxmox_virtual_environment_file.ubuntu_cloud_init.file_name
}
output "ubuntu_template_vm_name" {
  value = proxmox_virtual_environment_vm.ubuntu_vm_template.name
}
output "ubuntu_template_vm_id" {
  value = proxmox_virtual_environment_vm.ubuntu_vm_template.vm_id
}