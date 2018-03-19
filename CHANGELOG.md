# CHANGELOG

## 7.2.0 2018-03-18

- Use Flyway 5.0.7

## 7.1.1 2017-08-15

- Add respond_to? conditional to metadata chef version

## 7.1.0 2017-08-14

- Use Flyway 4.2.0
- Set MySQl driver to 5.1.43
- Use cookstyle for unit testing 

## 7.0.0 2017-04-01

- Rename params attribute to parameters to be Chef 13 compatible
- Use Flyway 4.1.2
- Set MySQl driver to 5.1.41

## 6.1.0 2017-02-10

- Use Flyway 4.1.1
- Set MySQl driver to 5.1.40

## 6.0.0 2016-08-23

- Append flywaydb directory to install directory e.g., /opt is now /opt/flywaydb
- Fix #30 Make flyway executable

## 5.6.0 2016-08-03 

- Use Flyway 4.0.3

## 5.5.2 2016-07-22

- Fix #27 Missing parameter 'run' in recursive process_conf call

## 5.5.1 2016-07-15

- Fix #25 Do not create a user/group when passing in values

## 5.5.0 2016-06-08

- Use Flyway 4.0.2
- Set MariaDB driver version to nil to use the MariaDB Connector/J driver that ships with flywaydb

## 5.4.0 2016-05-30

- Set MariaDB driver version to 1.4.5 
- Set MySQL driver version to 5.1.39

## 5.3.0 2016-05-22

- Add timeout option that defaults to 72hrs

## 5.2.1 2016-05-16

- Fix #20 MySQL driver missing when new version of flyway installed

## 5.2.0 2016-05-10

- Use Flyway 4.0.1

## 5.1.2 2016-05-06

- Fix #19 Cannot symlink flyway directory if older version of flywaydb cookbook ran previously
- Fix #18 MySQL driver should overwrite the old one
- Fix #17 System Error Message: Access is denied

## 5.1.1 2016-05-05

- Fix #16 Chef::Exceptions::NoSuchResourceType
- Fix #15 Flyway should automatically update if the version changes

## 5.1.0 2016-05-02

- Fix #13 Flyway 4.0 commandline creates empty metadata table

## 5.0.2 2016-04-21

- Fix #12 Blank flyway.conf if flyway_conf nil

## 5.0.1 2016-04-19

- Fix #9 Extracting to flyway-4.0 on windows

## 5.0.0 2016-04-15

- Add flyway_conf attribute
- Add alt_conf attribute
- Remove conf and ext_conf attributes

## 4.1.0 2016-04-14

- Fix #6 Suppress the command that was executed to hide sensitive 
information but still log stdout and stderr

## 4.0.1 2016-04-12

- Include default recipe in provide only if required

## 4.0.0 2016-03-24

- Fix #4 Quote param values to avoid interpretation by the shell 

## 3.1.0 2016-03-09

- Use Flyway 4.0

## 3.0.1 2016-03-08

- Fix #3 sensitive not defaulting to true
- Fix clean action

## 3.0.0 2016-02-20

- Remove global attributes ext_conf, conf, params, sensitive, and debug 
- Default sensitive to true

## 2.0.0 2016-02-10

- Remove command recipes

## 1.0.0 2016-02-04

- Initial release
