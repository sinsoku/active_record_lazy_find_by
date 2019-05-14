require "bundler/setup"
require "active_record_lazy_find_by"
require "active_record"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  ':memory:'
)

class User < ActiveRecord::Base
  include ActiveRecordLazyFindBy::Methods
end

class CreateUser < ActiveRecord::Migration[5.0]
  def self.up
    create_table(:users) do |t|
      t.string :name
      t.integer :age
    end
  end
end
CreateUser.up
