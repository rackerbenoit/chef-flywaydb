#!/usr/bin/env bats

@test "flyway binary is installed" {
  run stat /opt/flyway/flyway
  [ "$status" -eq 0 ]
}

@test "flyway.conf is created" {
  run cat /opt/flyway/conf/flyway.conf
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "flyway.url=jdbc:mysql://localhost/mysql" ]
  [ "${lines[1]}" = "flyway.schemas=flywaydb_test" ]
  [ "${lines[2]}" = "flyway.locations=filesystem:/tmp/db" ]
}
