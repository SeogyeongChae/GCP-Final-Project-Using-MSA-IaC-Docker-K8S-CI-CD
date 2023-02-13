resource "google_compute_router" "nat_router" {
  name    = "gcpzg-nat-router"
  region  = google_compute_subnetwork.gcpzg_subnet_ane3.region
  network = google_compute_network.gcpzg_vpc.id

  bgp {
    # Autonomous System Number => https://blog.naver.com/PostView.naver?blogId=taeheon714&logNo=222384978033&parentCategoryNo=&categoryNo=6&viewDate=&isShowPopularPosts=true&from=search
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "gcpzg-nat"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true # Indicates whether or not to export logs.
    filter = "ALL" # ERRORS_ONLY | TRANSLATIONS_ONLY | ALL
  }
}