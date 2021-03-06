# encoding: UTF-8
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :fatal
end

REDHAT_OPTS = {
  platform: 'redhat',
  version: '7.4',
}.freeze
UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '16.04',
}.freeze

shared_context 'database-stubs' do
  before do
    # for redhat
    stub_command("/usr/bin/mysql -u root -e 'show databases;'")
    # for debian
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'")
    stub_command("mysqladmin --user=root --password='' version")

    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('lo')
      .and_return('127.0.0.1')
    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('all')
      .and_return('0.0.0.0')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('db', anything)
      .and_return('test-pass')
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('db', 'mysqlroot')
      .and_return('abc123')
  end
end
