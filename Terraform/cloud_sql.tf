### prod db ###
resource "google_sql_database_instance" "gcpzg_db_ane3" {
  name                = "gcpzg-prod-db-ane3"
  database_version    = "MYSQL_5_7"
  deletion_protection = true

  settings {
    tier              = "db-n1-standard-2"
    availability_type = "REGIONAL"
    disk_size         = 10

    # 용량에 따라 저장소 크기 조절 가능!
    disk_autoresize = true
    disk_autoresize_limit = 20

    # DB 생성할 위치 지정
    location_preference {
      zone           = "asia-northeast3-a"
      secondary_zone = "asia-northeast3-b"
    }

    # DB IP 구성 설정
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.gcpzg_vpc.id
    }

    # DB 백업 구성 설정!
    backup_configuration {
      # MySQL에서만 사용 설정 가능하며 백업 및 복제에 사용함
      # 사용 설정 시 DB 속도가 살짝 느려진다고 함!(Google 피셜)
      binary_log_enabled = true
      enabled            = true
      start_time         = "04:00"
      location           = "asia-northeast3"
    }
  }
  depends_on = [google_service_networking_connection.db_connection]
}

# gcpzg_db_ane3 에 들어갈 데이터 베이스 생성 (petclinic이 기본적으로 사용하는 데이터베이스 이름)
resource "google_sql_database" "gcpzg_db_database" {
  instance = google_sql_database_instance.gcpzg_db_ane3.name
  name     = "petclinic"
}

# gcpzg_db_ane3의 사용자와 P/W 생성 (petclinic이 기본적으로 사용하는 사용자와 P/W)
resource "google_sql_user" "gcpzg_db_user" {
  instance = google_sql_database_instance.gcpzg_db_ane3.name
  name     = #
  password = #
}



############ test db #############
resource "google_sql_database_instance" "gcpzg_test_db_ane3" {
  name                = "gcpzg-test-db-ane3"
  database_version    = "MYSQL_5_7"
  deletion_protection = true

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size         = 10

    # 용량에 따라 저장소 크기 조절 가능!
    disk_autoresize = true
    disk_autoresize_limit = 20

    # DB 생성할 위치 지정
    location_preference {
      zone           = "asia-northeast3-a"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.gcpzg_vpc.id
    }
  }
  depends_on = [google_service_networking_connection.db_connection]
}
# gcpzg_db_ane3 에 들어갈 데이터 베이스 생성 (petclinic이 기본적으로 사용하는 데이터베이스 이름)
resource "google_sql_database" "gcpzg_test_db_database" {
  instance = google_sql_database_instance.gcpzg_test_db_ane3.name
  name     = "petclinic"
}

# gcpzg_db_ane3의 사용자와 P/W 생성 (petclinic이 기본적으로 사용하는 사용자와 P/W)
resource "google_sql_user" "gcpzg_test_db_user" {
  instance = google_sql_database_instance.gcpzg_test_db_ane3.name
  name     = #
  password = #
}




# VPC 피어링 용도의 서브넷 주소를 생성
resource "google_compute_global_address" "db_private_ip_address" {
  name          = "gcpzg-private-ip-address"

  # VPC_PEERING, PRIVATE_SERVICE_CONNECT 두 옵션 중에 사용해야하며 Private_~~~는 월 7만원 정도 비용 발생(시간당 100원)
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.gcpzg_vpc.id
}

# vpc와 db를 피어링하는 설정!!
resource "google_service_networking_connection" "db_connection" {
  network                 = google_compute_network.gcpzg_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_private_ip_address.name]
}

