# Flyway Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/flywaydb.svg?style=flat-square)][supermarket]
[![Build Status](http://img.shields.io/travis/dhoer/chef-flywaydb.svg?style=flat-square)][travis]

[supermarket]: https://supermarket.chef.io/cookbooks/flywaydb
[travis]: https://travis-ci.org/dhoer/chef-flywaydb

Installs [flywaydb](http://flywaydb.org) and allows for execution of flyway commands.

## Requirements

- Chef 11+

### Platforms

- CentOS/RedHat 
- Debian/Ubuntu
- Windows

## Usage

### Recipes

Include migrate, info, validate, baseline, or repair recipe in cookbook or run list to install flywaydb and execute 
flyway associated command.

#### Attributes

* `node['flywaydb']['conf']` (required) - A hash or array of hashes used to create the default Configuration file(s) 
for the flyway conf file. Key values automatically get prefixed with flyway.
* `node['flywaydb']['params']` - A hash of command-line parameters to pass to flyway command. Command-line parameters 
override Configuration files.
* `node['flywaydb']['name']` - The name of the flyway conf file. Default `flyway`.
* `node['flywaydb']['debug']` - Print debug output during execution of flyway commands. Default `false`.
* `node['flywaydb']['sensitive']` - Ensure that sensitive resource data is not logged by the 
chef-client. Default `false`.
* `node['flywaydb']['version']` - The flywaydb version to install. Default `3.2.1`.
* `node['flywaydb']['sha256']` - The flywaydb SHA 256 checksum for linux or windows platform.
* `node['flywaydb']['install_dir']` - The base install directory. Default linux: `/opt/flyway` windows: `C:\flyway`.
* `node['flywaydb']['user']` - The owner of flywaydb. Default `flyway`.
* `node['flywaydb']['group']` - The group of flywaydb. Default `flyway`.

#### Examples

Single flyway conf migration

```ruby
{
  "run_list": [
    "recipe[flywaydb::migrate]"
  ],
  "flywaydb": {
    "conf": {
      "url": "jdbc:mysql/localhost/mydb",
      "user": "root",
      "password": "changeme",
      "locations": "filesystem:/opt/myapp/db/migration"
    }
  }
}
```

Multiple flyway conf migrations with user and password passed as command-line parameters

```ruby
{
  "run_list": [
    "recipe[flywaydb::migrate]"
  ],
  "flywaydb": {
    "params": {
      "user": "root",
      "password": "changeme"    
    }
    "conf": [
      {
        "url": "jdbc:mysql/localhost/mysql",
        "schemas": "schema1",
        "locations": "classpath:com.mycomp.migration,database/migrations,filesystem:/sql-migrations"
      },
      {
        "url": "jdbc:mysql/localhost/mydb",
        "locations": "filesystem:/opt/myapp/db/migration"
      }
    ]
  }
}
```

### Resources

Use migrate, info, validate, baseline, or repair actions to install flywaydb and execute flyway associated command.

#### Attributes

* `conf` (required) - A hash or array of hashes used to create the default Configuration file(s) for the flyway conf 
file. Key values automatically get prefixed with flyway.
* `params` - A hash of command-line parameters to pass to flyway command. Command-line parameters override 
Configuration files.
* `name` - The name of the flyway conf file. Defaults to resource name.
* `debug` - Print debug output during execution of flyway commands. Default `false`.
* `quiet` -  Suppress all output, except for errors and warnings. Default `false`.
* `sensitive` - Ensure that sensitive resource data is not logged by the chef-client. Default `false`.

#### Examples

Single flyway conf migration

```ruby
flywaydb 'myapp' do
  conf {
    url: 'jdbc:mysql/localhost/mydb',
    user: 'root',
    password: 'changeme',
    locations: 'filesystem:/opt/myapp/db/migration'
  }
  action :migrate
end
```

Multiple flyway conf migrations with user and password passed as command-line parameters

```ruby
flywaydb 'myapp' do
  params {
    user: 'root',
    password: 'changeme'
  }
  conf [
    {
      url: 'jdbc:mysql/localhost/mysql',
      schemas: 'schema',
      locations: 'classpath:com.mycomp.migration,database/migrations,filesystem:/sql-migrations'
    },
    {
      url: 'jdbc:mysql/localhost/mydb',
      locations: 'filesystem:/opt/myapp/db/migration'
    }
  ]
  action :migrate
end
```

## ChefSpec Matchers

This cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to migrate_flywaydb('flyway').with(
  params {
      'user' => 'mysql',
      'password' => 'mysql'  
  }
  conf: [
    {
      'url' => 'jdbc:mysql://localhost/mysql',
      'schemas' => 'schema_a',
      'locations' => 'classpath:com.mycomp.migration,database/migrations,filesystem:/sql-migrations'
    },
    {
      'url' => 'jdbc:mysql://localhost/mysql',
      'schemas' => 'schema_b',
      'locations' => 'filesystem:/opt/myapp/db/migration'
    }
  ],
  debug: false,
  sensitive: false
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
