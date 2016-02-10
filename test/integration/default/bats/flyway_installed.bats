#!/usr/bin/env bats

@test "flyway binary is installed" {
  run stat /opt/flyway/flyway
  [ "$status" -eq 0 ]
}

@test "default flyway config is created" {
  run cat /tmp/conf/ext.conf
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "flyway.url=jdbc:mysql://localhost/mysql" ]
  [ "${lines[1]}" = "flyway.schemas=flywaydb_test" ]
  [ "${lines[2]}" = "flyway.locations=filesystem:/tmp/db" ]
  [ "${lines[3]}" = "flyway.placeholders.test_user=test" ]
}
