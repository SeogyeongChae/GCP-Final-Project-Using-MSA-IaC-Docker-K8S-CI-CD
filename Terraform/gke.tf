resource "google_container_cluster" "gke_ane3_prod" {
  name                     = "gcpzg-gke-prod-ane3" # 리소스 이름
  location                 = "asia-northeast3" # GKE 리전 설정
  node_locations           = ["asia-northeast3-a", "asia-northeast3-b", "asia-northeast3-c"] # 노드 위치(Zone) 선택, Default : google_container_cluster.gke_ane3_pro.location을 따라가며 3개 이상의 Zone이 설정됨
  remove_default_node_pool = true # 디폴트 노드 풀 제거
  initial_node_count       = 1    # 디폴트 노드 풀을 제거할 시 initial_node_count를 1로 설정해주어야함 (공식 문서 피셜)

  # horizontal pod autoscaling 사용
  # http lb 설정 사용(HTTP LB 구성을 조금 더 편리하게 할 수 있도록 해줌) => 실제로 보지 못해서 아직 정확히 모르겠음.
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false # Default = false
    }
    http_load_balancing {
      disabled = false # Default = false
    }
  }

  # 파드 수직 확장 사용 정책
  vertical_pod_autoscaling {
    enabled = false
  }

  # VPC Native Settings
  ip_allocation_policy {
  }

  network    = google_compute_network.gcpzg_vpc.name
  subnetwork = google_compute_subnetwork.gcpzg_subnet_ane3.name

  logging_service = "logging.googleapis.com/kubernetes" # Default      

  # show traffics node -> pod (for test)
  enable_intranode_visibility = true

  node_config {
    #service_account = google_service_account.gke_svc_account.email
    oauth_scopes = ["cloud-platform"]
    machine_type = "e2-medium"
    disk_type = "pd-standard"
    disk_size_gb = "10"
  }

  # private gke setting
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.0.0/28" # Default IP Range

    master_global_access_config {
      enabled = true
    }
  }

  lifecycle {ignore_changes = all}
}
##
###################### node pool ######################
resource "google_container_node_pool" "gke_node_pool_abc_prod" {
  name       = "gcpzg-nodepool-prod-ane3-abc"
  cluster    = google_container_cluster.gke_ane3_prod.id
  node_count = 2

  autoscaling {
    min_node_count = 2
    max_node_count = 6
    #    location_policy      = "BALANCED"
  }

  # 노드 관리 옵션
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    #service_account = google_service_account.gke_svc_account.email
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    machine_type = "e2-medium"
    disk_type = "pd-standard"
    disk_size_gb = "10"
  }

  lifecycle {ignore_changes = all}
}



############################# Test env ############################
resource "google_container_cluster" "gke_ane3_test" {
  name                     = "gcpzg-gke-test-ane3" # 리소스 이름
  location                 = "asia-northeast3" # GKE 리전 설정
  # node_locations           = ["asia-northeast3-a"] # 노드 위치(Zone) 선택, Default : google_container_cluster.gke_ane3_pro.location을 따라가며 3개 이상의 Zone이 설정됨
  remove_default_node_pool = true # 디폴트 노드 풀 제거
  initial_node_count       = 1    # 디폴트 노드 풀을 제거할 시 initial_node_count를 1로 설정해주어야함 (공식 문서 피셜)

  # horizontal pod autoscaling 사용
  # http lb 설정 사용(HTTP LB 구성을 조금 더 편리하게 할 수 있도록 해줌) => 실제로 보지 못해서 아직 정확히 모르겠음.
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false # Default = false
    }
    http_load_balancing {
      disabled = false # Default = false
    }
  }

  # 파드 수직 확장 사용 정책
  vertical_pod_autoscaling {
    enabled = false
  }

  # VPC Native Settings
  ip_allocation_policy {
  }

  network    = google_compute_network.gcpzg_vpc.name
  subnetwork = google_compute_subnetwork.gcpzg_subnet_ane3.name

  logging_service = "logging.googleapis.com/kubernetes" # Default      

  # show traffics node -> pod (for test)
  enable_intranode_visibility = true

  node_config {
    #service_account = google_service_account.gke_svc_account.email
    oauth_scopes = ["cloud-platform"]
    machine_type = "e2-small"
    disk_size_gb = "10"
  }

  # private gke setting
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.1.0.0/28" # Default IP Range

    master_global_access_config {
      enabled = true
    }
  }

  #lifecycle {ignore_changes = all}
}

###################### node pool ######################
resource "google_container_node_pool" "test_node_pool_ane3_a" {
  name       = "gcpzg-nodepool-test-ane3"
  cluster    = google_container_cluster.gke_ane3_test.id
  node_count = 2

  autoscaling {
    min_node_count = 2
    max_node_count = 10
    #    location_policy      = "BALANCED"
  }

  # 노드 관리 옵션
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    #service_account = google_service_account.gke_svc_account.email
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    machine_type = "e2-small"
    disk_size_gb = "10"
  }

  #lifecycle {ignore_changes = all}
}