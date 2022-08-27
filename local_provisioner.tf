# Local Provisioner - Runs on your local Macbook Pro/Linux instance to add a Kubernetes Context to your local machine.

resource "null_resource" "local_mac_provisioner" {
  provisioner "local-exec" {
    command = <<EOT
        echo "# Running local provisioner to add Kubernetes context"
        gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.zone}
        EOT
  }

  depends_on = [google_container_node_pool.primary_nodes]
}