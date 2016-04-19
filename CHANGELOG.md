# CHANGELOG

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
