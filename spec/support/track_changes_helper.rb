shared_examples TrackChanges do |sample_column|
  it 'starts with no last_changes' do
    subject.save!
    expect(subject.last_changed).to be_blank
    expect(subject.last_changes).to be_blank
  end

  it 'adds last changes on update' do
    subject.save!
    old = subject.send(sample_column)
    admin = create(:admin)
    subject.send("#{sample_column}=", 'new value')
    subject.current_admin = admin
    subject.save!
    expect(subject.last_changed).to be_equal(admin)
    expect(subject.last_changes[sample_column.to_s]).to be_eql([old, 'new value'])
  end

  it 'does not update last_changes if there are no changes' do
    subject.save!
    subject.update(sample_column => 'new value')
    expect(subject.last_changes).to_not be_blank
    last_changes = subject.last_changes
    subject.save!
    expect(subject.last_changes).to be_eql(last_changes)
  end
end
