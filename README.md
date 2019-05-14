# ActiveRecordLazyFindBy

`ActiveRecordLazyFindBy` provides simple lazy methods that be able to reduce SQL issuance slightly.

## :package: Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_lazy_find_by'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_lazy_find_by

## :memo: Usage

For example, you have defined the following table and class:

```ruby
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  age        :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  include ActiveRecordLazyFindBy::Methods

  has_many :posts
end
```

The `lazy_find_by` returns an instance that does not execute SQL until it is needed.

```ruby
user = User.lazy_find_by(id: 1, name: "foo")
#=> #<User id: 1, name: "foo", age: nil, created_at: nil, updated_at: nil>
user.id
#=> 1
user.name
#=> "foo"
user.age
  User Load (0.4ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
#=> 39
```

### :+1: Find by relations

It executes SQL for relations, but it does not execute SQL for `users` table.

```ruby
user = User.lazy_find_by(id: 1, name: "foo")
user.posts.find_by(id: 1)
  Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ? AND "posts"."id" = ? LIMIT ?  [["user_id", 1], ["id", 1], ["LIMIT", 1]]
#=> #<Post id: 1, user_id: 1, title: "bar", created_at: "2019-05-10 15:44:39", updated_at: "2019-05-10 15:44:39">
```

### :green_heart: Pass only `id` attribute

This gem provides the `lazy_find` method that be able to pass only `id` attribute.

```ruby
user = User.lazy_find(1)
user.id
#=> 1
user.name
  User Load (0.4ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
#=> "dhh"
```

## :warning: Caution

`lazy_find_by` and `lazy_find` methods does not execute SQL immediately, so an instance that returns by these methods may be older than databases.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sinsoku/active_record_lazy_find_by. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveRecordLazyFindBy project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/active_record_lazy_find_by/blob/master/CODE_OF_CONDUCT.md).
