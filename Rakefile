task default: :test

desc "Run all specs"
task :test do
  sh "ruby -I. -Ilib #{FileList['test/**/*_test.rb'].map { |t| "-r #{t}" }} -e ''"
end