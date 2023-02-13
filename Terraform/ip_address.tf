resource "google_compute_global_address" "ingress_ip" {
  name = "ingress-static-ip"
  // INTERNAL, EXTERNAL
 # address_type = "EXTERNAL"  // Default : EXTERNAL
}
