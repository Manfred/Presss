require File.expand_path('../../preamble', __FILE__)

describe "A", Presss::HTTP do
  before do
    Presss.config = {
      :bucket_name => 'press-test',
      :access_key_id => 'ad76fg87',
      :secret_access_key => 'js34iu78erpo89',
    }
    @http = Presss::HTTP.new(Presss.config)
  end

  it "uses the correct domain" do
    @http.domain.should == 's3.amazonaws.com'
    Presss.config[:region] = 'us-east-1'
    @http.domain.should == 's3.amazonaws.com'
    Presss.config[:region] = 'eu-west-1'
    @http.domain.should == 's3-eu-west-1.amazonaws.com'
  end
end