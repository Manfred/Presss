require 'rubygems'
require 'bundler/setup'
require 'peck/flavors/vanilla'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'presss'

$:.unshift File.expand_path('../mocks', __FILE__)
require 'http'

module Helpers
  module Fixtures
    def fixture_path
      File.expand_path('../fixtures', __FILE__)
    end

    def fixture_file_path(path)
      File.join(fixture_path, 'files', path)
    end

    def read_fixture(path)
      File.read(path)
    end

    def fixture_file(path)
      read_fixture(fixture_file_path(path))
    end
  end
end

Peck::Context.once do |context|
  context.before do
    extend Helpers::Fixtures
  end
end