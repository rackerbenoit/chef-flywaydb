# Flywaydb Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/flywaydb.svg?style=flat-square)][supermarket]
[![linux](http://img.shields.io/travis/dhoer/chef-flywaydb/master.svg?label=linux&style=flat-square)][linux]
[![win](https://img.shields.io/appveyor/ci/dhoer/chef-flywaydb/master.svg?label=windows&style=flat-square)][win]

[supermarket]: https://supermarket.chef.io/cookbooks/flywaydb
[linux]: https://travis-ci.org/dhoer/chef-flywaydb
[win]: https://ci.appveyor.com/project/dhoer/chef-flywaydb

Installs [flywaydb](http://flywaydb.org) and allows for execution of flyway commands via resource 
actions.  

Connector/J Drivers

- To use a MariaDB Connector/J driver version other than the one that ships with flywaydb, set
`node['flywaydb']['mariadb']['version']` attribute to 
[version](http://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/) desired. 
- To use MySQL Connector/J driver instead of MariaDB Connector/J driver for jdbc:mysql: connections, 
set `mysql_driver` attribute to true.

## Requirements

- Chef 11+

### Platforms

- CentOS/RedHat
- Debian/Ubuntu
- Windows

## Usage

Use migrate, info, validate, baseline, or repair actions to _install_ 
flywaydb (if not installed) and _execute_ associated flyway command. 
An install action is also available if you just want to install 
flywaydb but not execute any flyway commands.

### Attributes

* `flyway_conf` - Configuration path or settings to copy or 
create `conf/flyway.conf`.  The flyway.conf file will be 
regenerated for each flywaydb execution and will be blanked out if 
flyway_conf is nil to prevent alt_conf from inadvertently inheriting 
its settings. Settings in alt_conf override settings in flyway.conf. 
Settings in parameters override all settings. Default: `nil`.
* `alt_conf` -  Alternative configuration path or settings. An array
containing paths and/or settings is also supported.  Each path and 
settings are written as `conf/#{name}[_#{i + 1}].conf` 
where name is the resource name and i is the index in array. Each item 
in array will result in an independent execution of Flyway. Settings in 
alt_conf override settings in flyway.conf. Settings in parameters override 
all settings. Default: `nil`. 
* `parameters` - Command-line parameters to pass to flyway command. 
Settings in parameters override all settings. Default: `{}`.
* `mysql_driver` - MariaDB Connector/J driver is the default driver 
for *jdbc:mysql:* connections.  Set to true to download and install 
MySQL Connector/J driver under `drivers` directory. This will then 
become the default driver for *jdbc:mysql:* connections. 
Default: `false`.
* `name` - Name of the alternative conf file when alt_conf is defined. 
Defaults to resource block name.
* `install_dir` - The base install directory. Default Linux: `/opt/flywaydb` 
Windows: `#{ENV['SYSTEMDRIVE']}/flywaydb`.
* `debug` - Print debug output during execution of flyway commands. 
Default: `false`.
* `user` -  The owner of flywaydb. Creates a flyway user when nil or uses 
value passed in. Default `nil`.
* `group` - The group of flywaydb. Creates flyway or modifies Administrators 
group when nil (or set to Administrators on Windows for backwards 
compatibility) or uses value passed in. Default `nil`.
* `password` - Required only on Windows Servers that throw 'The 
password does not meet the password policy requirements.' error when 
creating flyway user. Default: `nil`.
* `sensitive` - Suppress logging the Flyway command executed to hide 
sensitive information but still log Flyway stdout and stderr to 
Chef-client.  Writing of conf files will also be suppressed when
executing with Chef-client versions that support sensitive. 
Default: `true`.
* `timeout` - Number of seconds to wait on flyway process before 
raising an Exception. Default: `259_200` (72hrs).

### Examples

#### Single migration using settings

```ruby
flywaydb 'myapp' do
  flyway_conf(
    url: 'jdbc:mysql//localhost/mydb',
    user: 'root',
    locations: 'filesystem:/opt/myapp/db/migration',
    cleanDisabled: true
  )
  action :migrate
end
```

#### Single migration using file path

```ruby
flywaydb 'myapp' do
  flyway_conf(
    '/opt/myapp/db/flyway.conf'
  )
  action :migrate
end
```

#### Multiple migrations using settings   

```ruby
flywaydb 'myapp' do
  flyway_conf(
    user: 'root',
    url: 'jdbc:mysql//localhost/mysql'
  )
  alt_conf([
    {
      schemas: 'custA',
      locations: 'filesystem:/opt/myapp/db/migration/core,/opt/myapp/db/migration/custA'
    },
    {
       schemas: 'custB',
       locations: 'filesystem:/opt/myapp/db/migration/core,/opt/myapp/db/migration/custB'
    }
  ])
  parameters(
    password: password   
  )
  action :migrate
end
```

#### Multiple migrations using file paths

```ruby
flywaydb 'myapp' do
  flyway_conf(
    '/opt/myapp/db/flyway.conf'
  )
  alt_conf([
    '/opt/myapp/db/custA.conf',
    '/opt/myapp/db/custB.conf'
  ])
  parameters(
    password: password   
  )
  action :migrate
end
```

## ChefSpec Matchers

This cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to migrate_flywaydb('flyway').with(
  flyway_conf: {
      'user' => 'root',
      'url' => 'jdbc:mysql://localhost/mysql'
  }
  alt_conf: [
    {
      'schemas' => 'custA',
      'locations' => 'filesystem:/opt/myapp/db/migration/core,/opt/myapp/db/migration/custA'
    },
    {
      'schemas' => 'custB',
      'locations' => 'filesystem:/opt/myapp/db/migration/core,/opt/myapp/db/migration/custB'
    }
  ],
  parameters: {
      'password' => 'password'
  }
  debug: false,
  sensitive: true
)
```
      
Cookbook Matchers

- migrate_flywaydb(resource_name)
- clean_flywaydb(resource_name)
- baseline_flywaydb(resource_name)
- info_flywaydb(resource_name)
- repair_flywaydb(resource_name)
- validate_flywaydb(resource_name)
- install_flywaydb(resource_name)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/flyway).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-flywaydb/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-flywaydb/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-flywaydb/blob/master/LICENSE.md) file for details.
