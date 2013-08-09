Gem::Specification.new do |spec|
  spec.name = 'presss'
  spec.version = '0.9.0'

  spec.author = "Manfred Stienstra"
  spec.email = "manfred@fngtps.com"

  spec.description = <<-EOF
    Presss tries to be the simplest S3 library possible.
  EOF
  spec.summary = <<-EOF
    Presss uploads objects to and downloads objects from from Amazon S3. It's
    a tiny companion to a more complete implementation like AWS SDK.
  EOF

  spec.files = Dir.glob("{lib,support}/**/*") + %w(COPYING README.md)

  spec.has_rdoc = true
  spec.extra_rdoc_files = ['COPYING']
  spec.rdoc_options << "--charset=utf-8"
end