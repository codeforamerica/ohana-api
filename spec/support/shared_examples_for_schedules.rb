shared_examples 'validating opens_at and closes_at values' do |model, attribute|
  it 'converts 18:00' do
    rs = build(model, attribute => '18:00')
    rs.valid?
    expect(rs.send(attribute)).to eq(Time.utc(2000, 1, 1, 18, 00, 0))
  end

  it 'converts 5am' do
    rs = build(model, attribute => '5am')
    rs.valid?
    expect(rs.send(attribute)).to eq(Time.utc(2000, 1, 1, 5, 00, 0))
  end

  it 'converts 7pm' do
    rs = build(model, attribute => '7pm')
    rs.valid?
    expect(rs.send(attribute)).to eq(Time.utc(2000, 1, 1, 19, 00, 0))
  end
end
