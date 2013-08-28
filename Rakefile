task :default => :test

desc "Run all specs"
task :test do
  sh "ruby -I. -Ilib #{FileList['test/unit/*_test.rb'].map { |t| "-r #{t}" }} -e ''"
end

namespace :test do
  desc "Run all remote specs"
  task :remote do
    sh "ruby -I. -Ilib #{FileList['test/remote/*_test.rb'].map { |t| "-r #{t}" }} -e ''"
  end
end