shared_examples_for 'rate limit reached' do
  it 'returns a 403 status' do
    response.status.should == 403
  end

  it 'returns a rate limited exceeded body' do
    json['description'].should == 'Rate limit exceeded'
  end

  it 'does not return the remaining requests header' do
    headers['X-RateLimit-Remaining'].should be_nil
  end

  it "does not return a 'Retry-After' header" do
    headers['Retry-After'].should be_nil
  end

  it 'returns a content-type of json' do
    headers['Content-Type'].should include 'application/json'
  end
end
