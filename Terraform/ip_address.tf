resource "google_compute_global_address" "ingress_ip" {
  name = "ingress-static-ip"
  // INTERNAL, EXTERNAL 두 종류가 있음
 # address_type = "EXTERNAL"  // Default : EXTERNAL
}
