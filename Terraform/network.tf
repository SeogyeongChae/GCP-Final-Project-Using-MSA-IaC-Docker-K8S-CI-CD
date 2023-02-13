resource "google_compute_network" "gcpzg_vpc" {
  name                    = "gcpzg-vpc"
  auto_create_subnetworks = false

  # mtu(최대 전송 단위) 설정 옵션(default = 1460) 최댓값 = 1500
  # mtu = 1460 #default: 1460
}

resource "google_compute_subnetwork" "gcpzg_subnet_ane3" {
  name          = "gcpzg-subnet-ane3"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.gcpzg_vpc.id

  # 비공개 구글 액세스 사용 설정(DB 등 액세스 용도)
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_30_SEC"
    flow_sampling = "0.5"
  }
}