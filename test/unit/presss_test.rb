require File.expand_path('../../preamble', __FILE__)

describe Presss, "without configuration" do
  it "complains" do
    lambda do
      Presss.get('')
    end.should.raise(ArgumentError)
  end
end

describe Presss, "with a valid configuration" do
  before do
    Presss.config = {
      bucket_name: 'press-test',
      access_key_id: 'ad76fg87',
      secret_access_key: 'js34iu78erpo89'
    }
    # Send a blank 200 by default
    Net::FakeHTTP.next_response = nil
  end

  it "sends the correct request for a get" do
    Presss.get('wads/df45ui67.zip')

    request = Net::FakeHTTP.requests.last
    # Don't like this, but unfortunately Net::HTTP is really closed
    headers = request.instance_eval { @header }

    request.should.be.kind_of(Net::HTTP::Get)
    request.path.should == '/wads/df45ui67.zip'
    headers['date'][0].should.start_with(Time.now.rfc2822[0,20])
    headers['authorization'][0].should.start_with('AWS')
    headers['content-type'].should.be.nil
  end

  it "sends the correct request for a put" do
    body = fixture_file('wads/df45ui67.zip')
    Presss.put('wads/df45ui67.zip', body)

    request = Net::FakeHTTP.requests.last
    # Don't like this, but unfortunately Net::HTTP is really closed
    headers = request.instance_eval { @header }

    request.should.be.kind_of(Net::HTTP::Put)
    request.path.should == '/wads/df45ui67.zip'
    request.body.should == body
    headers['date'][0].should.start_with(Time.now.rfc2822[0,20])
    headers['authorization'][0].should.start_with('AWS')
    headers['content-type'].should.be.nil
  end

  it "uses the optional content type when putting an object" do
    content_type = 'application/zip'
    body = fixture_file('wads/df45ui67.zip')
    Presss.put('wads/df45ui67.zip', body, content_type)
    request = Net::FakeHTTP.requests.last
    # Don't like this, but unfortunately Net::HTTP is really closed
    headers = request.instance_eval { @header }
    headers['content-type'][0].should == content_type
  end

  it "gets the contents of a file" do
    Net::FakeHTTP.next_response = Net::FakeHTTP::Response.new(200, {}, "THIS IS A ZIP")
    Presss.get('wads/df45ui67.zip').should == "THIS IS A ZIP"
  end
  
  it "puts a file" do
    Net::FakeHTTP.next_response = Net::FakeHTTP::Response.new(200, {}, " ")
    Presss.put('wads/df45ui67.zip', fixture_file('wads/df45ui67.zip')).should == true
  end
end