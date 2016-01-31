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

Include recipe (migrate, info, validate, baseline, or repair) in cookbook or run list to install flywaydb and execute 
flyway associated command.

#### Attributes

* `node['flywaydb']['name']` - The name of the flyway conf file. Default `flyway`.
* `node['flywaydb']['conf']` - A hash or array used to create the default configuration for the flyway conf file. Key 
values automatically get prefixed with flyway. Default `nil`.
* `node['flywaydb']['debug']` - Print debug output during execution of flyway commands. Default `false`.
* `node['flywaydb']['sensitive']` - Ensure that sensitive resource data is not logged by the 
chef-client. Default `false`.
* `node['flywaydb']['version']` - The version of fly to install. Default `3.2.1`.
* `node['flywaydb']['install_dir']` - The base install directory. Default linux: `/opt/flyway` windows: `C:\flyway`.
* `node['flywaydb']['user']` - The owner of the flyway install. Default `flyway`.
* `node['flywaydb']['group']` - The group of the flyway install. Default `flyway`.

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

Multiple flyway conf migrations

```ruby
{
  "run_list": [
    "recipe[flywaydb::migrate]"
  ],
  "flywaydb": {
    "conf": [
      {
        "url": "jdbc:mysql/localhost/mysql",
        "user": "root",
        "password": "changeme",
        "schemas": "schema1",
        "locations": "classpath:com.mycomp.migration,database/migrations,filesystem:/sql-migrations"
      },
      {
        "url": "jdbc:mysql/localhost/mydb",
        "user": "root",
        "password": "changeme",
        "locations": "filesystem:/opt/myapp/db/migration"
      }
    ]
  }
}
```

### Resources

Use actions (migrate (default), clean, info, validate, baseline, or repair) to install flywaydb and execute 
flyway associated command.

#### Attributes

* `name` - The name of the flyway conf file. Defaults to resource name.
* `conf` - A hash or array of hashes used to create the default configuration for the flyway conf file. Key 
values automatically get prefixed with flyway. Default `nil`.
* `debug` - Print debug output during execution of flyway commands. Default `false`.
* `sensitive` - Ensure that sensitive resource data is not logged by the chef-client. Default `false`.

Single flyway conf migration

```ruby
flywaydb 'myapp' do
  conf({
    url: 'jdbc:mysql/localhost/mydb',
    user: 'root',
    password: 'changeme',
    locations: 'filesystem:/opt/myapp/db/migration'
  })
  action :migrate
end
```

Multiple flyway conf migrations

```ruby
flywaydb 'myapp' do
  conf([
    {
      url: 'jdbc:mysql/localhost/mysql',
      user: 'root',
      password: 'changeme',
      schemas: 'schema',
      locations: 'classpath:com.mycomp.migration,database/migrations,filesystem:/sql-migrations'
    },
    {
      url: 'jdbc:mysql/localhost/mydb',
      user: 'root',
      password: 'changeme',
      locations: 'filesystem:/opt/myapp/db/migration'
    }
  ])
  action :migrate
end
```

## ChefSpec Matchers

This cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to migrate_flywaydb('flyway').with(
  conf: [
    {
      'url' => 'jdbc:mysql://localhost/mysql',
      'user' => 'mysql',
      'password' => 'mysql',
      'schemas' => 'schema_a'
    },
    {
      'url' => 'jdbc:mysql://localhost/mysql',
      'user' => 'mysql',
      'password' => 'mysql',
      'schemas' => 'schema_b'
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
