require 'yaml'

remote_config_file = File.expand_path('../credentials.yml', __FILE__)

def assert(expression)
  if (!expression)
    raise RuntimeError, "Assertion failed"
  end
end

def report(message)
  puts message
end

if File.exist?(remote_config_file)
  require 'logger'

  $:.unshift File.expand_path('../../../lib', __FILE__)
  require 'presss'
  
  Presss.logger = Logger.new($stdout)
  Presss.config = YAML.load_file(remote_config_file)

  key = 'wads/df45ui67.zip'
  filename = File.expand_path('../../fixtures/files/wads/df45ui67.zip', __FILE__)
  result = Presss.put(key, open(filename))
  assert(result == true)

  contents = Presss.get(key)
  assert(contents == 'THIS IS A ZIP')

  contents = ''
  Presss.get(key) { |segment| contents << segment }
  assert(contents == 'THIS IS A ZIP')
else

  example = {
    :bucket_name => 'your-bucket-name',
    :access_key_id =>  'your-access-key-id',
    :secret_access_key => 'your-secret-access-key'
  }
  report("Please configure a test S3 bucket when running the remote tests:\n#{remote_config_file}\n#{example.to_yaml}")
end
