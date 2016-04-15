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

Use migrate, info, validate, baseline, or repair actions to _install_ flywaydb and execute associated flyway command.

#### Attributes

* `flyway_conf` -  A file path string or a hash of configuration settings to copy to or write to 
`#{install_dir}/conf/flyway.conf`.  Configuration settings in alt_conf override settings configured 
in flyway.conf. Settings in params override all other settings. Default: `nil`.
* `alt_conf` -  Alternative configuration file path string or a hash of configuration settings. An array
of both strings and/or hashes is also supported.  Hash(es) are written as 
`#{install_dir}/conf/#{name}[_#{i + 1}].conf` where name is the Flyway resource name and for arrays 
the i is the index where a hash was found in array. File path(s) are run as is.  Each item in an array will 
result in an independent execution of Flyway. Configuration settings in alt_conf override settings configured 
in flyway.conf. Settings in params override all other settings. Default: `nil`. 
* `params` - A hash of command-line parameters to pass to flyway command. Settings in params override all 
other configuration settings. Default: `{}`.
* `name` - The name of the flyway conf file when alt_conf is defined. Defaults to resource name.
* `debug` - Print debug output during execution of flyway commands. Default: `false`.
* `sensitive` - Suppress logging the Flyway command that was executed to hide sensitive information but still log Flyway
stdout and stderr to chef-client.  Default: `true`.

#### Examples

##### Single migration 

```ruby
flywaydb 'myapp' do
  flyway_conf(
    url: 'jdbc:mysql/localhost/mydb',
    user: 'root',
    locations: 'filesystem:/opt/myapp/db/migration'
    cleanDisabled: true
  )
  action :migrate
end
```

##### Single migration using file path

```ruby
flywaydb 'myapp' do
  flyway_conf(
    '/opt/myapp/db/flyway.conf'
  )
  action :migrate
end
```

##### Multiple migrations with command-line parameters

```ruby
flywaydb 'myapp' do
  params(
    password: password   
  )
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
  action :migrate
end
```

##### Multiple migrations with command-line parameters and file paths

```ruby
flywaydb 'myapp' do
  params(
    password: password   
  )
  flyway_conf(
    '/opt/myapp/db/flyway.conf'
  )
  alt_conf(
    '/opt/myapp/db/custA.conf',
    '/opt/myapp/db/custB.conf'
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
  params: {
      'password' => 'password'
  }
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
