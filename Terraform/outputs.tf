# db private ip 설정
output "PROD_DB_PRIVATE_IP" {
  description = "Internal IP Address of prod Cloud SQL"
  value       = google_sql_database_instance.gcpzg_db_ane3.private_ip_address
}

# test db private ip 설정
output "TEST_DB_PRIVATE_IP" {
  description = "Internal IP Address of test Cloud SQL"
  value       = google_sql_database_instance.gcpzg_test_db_ane3.private_ip_address
}

# external ip 설정
output "LB_External_IP" {
  description = "LB External IP address"
  value = google_compute_global_address.ingress_ip.address
}
