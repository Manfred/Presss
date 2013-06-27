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