require File.expand_path('../../preamble', __FILE__)

describe "A", Presss::Authorization do
  before do
    @authorization = Presss::Authorization.new(
      'AKIAIOSFODNN7EXAMPLE',
      'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    )
  end

  it "signs strings" do
    @authorization.sign("GET\n\n\nTue, 27 Mar 2007 19:36:42 +0000\n/johnsmith/photos/puppy.jpg").should == "bWq2s1WEIj+Ydj0vQ697zp+IXMU="
  end

  it "generates an authorization header value" do
    message = "GET\n\n\nTue, 27 Mar 2007 19:36:42 +0000\n/johnsmith/photos/puppy.jpg"
    @authorization.header(message).should == "AWS #{@authorization.access_key_id}:#{@authorization.sign(message)}"
  end
end