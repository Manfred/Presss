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

require 'digest/md5'
srand

if File.exist?(remote_config_file)
  def generate_key
    "wads/#{Digest::MD5.hexdigest(rand(100).to_s + Time.now.to_s)}.zip"
  end

  require 'logger'

  $:.unshift File.expand_path('../../../lib', __FILE__)
  require 'presss'
  
  Presss.logger = Logger.new($stdout)
  Presss.config = YAML.load_file(remote_config_file)

  key_one = generate_key
  key_two = generate_key

  filename = File.expand_path('../../fixtures/files/wads/df45ui67.zip', __FILE__)

  result = Presss.put(key_one, File.read(filename))
  assert(result == true)

  contents = Presss.get(key_one)
  assert(contents == 'THIS IS A ZIP')

  result = Presss.put(key_two, open(filename))
  assert(result == true)

  contents = ''
  Presss.get(key_two) { |segment| contents << segment }
  assert(contents == 'THIS IS A ZIP')
else

  example = {
    :bucket_name => 'your-bucket-name',
    :access_key_id =>  'your-access-key-id',
    :secret_access_key => 'your-secret-access-key'
  }
  report("Please configure a test S3 bucket when running the remote tests:\n#{remote_config_file}\n#{example.to_yaml}")
end
