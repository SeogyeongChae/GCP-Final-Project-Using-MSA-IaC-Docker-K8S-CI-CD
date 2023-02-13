resource "google_dns_managed_zone" "petclinic_dns" {
  name        = "petclinic" # Required
  dns_name    = "petclinic.shop." # Required
  # Logging 사용 설정
  cloud_logging_config {
    enable_logging = true
  }
}

# a 레코드 추가
resource "google_dns_record_set" "a_record" {
  name         = "www.${google_dns_managed_zone.petclinic_dns.dns_name}" # Required
  managed_zone = google_dns_managed_zone.petclinic_dns.name # Required
  type         = "A" # Required, | TXT, CNAME ... (DNS Record Set Type)
  ttl          = 300

  # External IP(Ingress)과 연결
  rrdatas = [google_compute_global_address.ingress_ip.address]

  depends_on = [google_compute_global_address.ingress_ip]
}