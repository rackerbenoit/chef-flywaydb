# Flywaydb Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/flywaydb.svg?style=flat-square)][supermarket]
[![Build Status](http://img.shields.io/travis/dhoer/chef-flywaydb.svg?style=flat-square)][travis]

[supermarket]: https://supermarket.chef.io/cookbooks/flywaydb
[travis]: https://travis-ci.org/dhoer/chef-flywaydb

Installs [flywaydb](http://flywaydb.org) and allows for execution of flyway commands via resource actions.

## Requirements

- Chef 11+

### Platforms

- CentOS/RedHat 
- Ubuntu
- Windows

## Usage

Include default recipe in cookbook or run list to install flywaydb. 

#### Attributes

* `node['flywaydb']['version']` - The flywaydb version to install. Default `4.0`.
* `node['flywaydb']['sha256']` - The flywaydb SHA 256 checksum for linux or windows platform.
* `node['flywaydb']['install_dir']` - The base install directory. Default linux: `/opt/flyway` windows: `C:\flyway`.
* `node['flywaydb']['user']` - The owner of flywaydb. Default `flyway`.
* `node['flywaydb']['group']` - The group of flywaydb. Default `flyway`.

### Resources

Use migrate, info, validate, baseline, or repair actions to _install_ flywaydb and _execute_ associated flyway command.

#### Attributes

* `flyway_conf` -  Flyway configuration path or settings to copy or create as 
`#{install_dir}/conf/flyway.conf` accordingly.  Settings in alt_conf override settings 
in flyway.conf. Settings in params override all settings. Default: `nil`.
* `alt_conf` -  Alternative configuration path or settings. An array
of both paths and/or settings is also supported.  Each path or settings are written as 
`#{install_dir}/conf/#{name}[_#{i + 1}].conf` where name is the resource name and i is the index 
in array. Each item in an array will result in an independent execution of Flyway. Settings in alt_conf 
override settings in flyway.conf. Settings in params override all settings. Default: `nil`. 
* `params` - Command-line parameters to pass to flyway command. Settings in params 
override all settings. Default: `{}`.
* `name` - Name of the alternative conf file when alt_conf is defined. Defaults to resource block name.
* `debug` - Print debug output during execution of flyway commands. Default: `false`.
* `sensitive` - Suppress logging the Flyway command executed to hide sensitive information but 
still log Flyway stdout and stderr to Chef-client.  Writing of conf files will also be suppressed when
executing with Chef-client versions that support sensitive. Default: `true`.

#### Examples

##### Single migration using settings

```ruby
flywaydb 'myapp' do
  flyway_conf(
    url: 'jdbc:mysql/localhost/mydb',
    user: 'root',
    locations: 'filesystem:/opt/myapp/db/migration',
    cleanDisabled: true
  )
  action :migrate
end
```

##### Single migration using path

```ruby
flywaydb 'myapp' do
  flyway_conf(
    '/opt/myapp/db/flyway.conf'
  )
  action :migrate
end
```

##### Multiple migrations using settings with alt_conf and params 

```ruby
flywaydb 'myapp' do
  flyway_conf(
    user: 'root',
    url: 'jdbc:mysql/localhost/mysql'
  )
  alt_conf(
    {
      schemas: 'custA',
      locations: 'filesystem:/opt/myapp/db/migration/core,/opt/myapp/db/migration/custA'
    },
    {
       schemas: 'custB',
       locations: 'filesystem:/opt/myapp/db/migration/core,/opt/myapp/db/migration/custB'
    }
  )
  params(
    password: password   
  )
  action :migrate
end
```

##### Multiple migrations using paths with alt_conf and params 

```ruby
flywaydb 'myapp' do
  flyway_conf(
    '/opt/myapp/db/flyway.conf'
  )
  alt_conf(
    '/opt/myapp/db/custA.conf',
    '/opt/myapp/db/custB.conf'
  )
  params(
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
  flyway_conf_: {
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
  params: {
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

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/flyway).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-flywaydb/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-flywaydb/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-flywaydb/blob/master/LICENSE.md) file for details.
