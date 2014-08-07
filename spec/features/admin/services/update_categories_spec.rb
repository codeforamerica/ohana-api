require 'rails_helper'

feature 'Update categories' do
  background do
    create_service
    emergency = Category.create!(name: 'Emergency', oe_id: '101')
    emergency.children.create!(name: 'Disaster Response', oe_id: '101-01')
    emergency.children.create!(name: 'Subcategory 2', oe_id: '101-02')
    emergency.children.create!(name: 'Subcategory 3', oe_id: '101-03')

    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'when adding one subcategory', :js do
    check 'category_101'
    check 'category_101-01'
    click_button 'Save changes'

    expect(find('#category_101')).to be_checked
    expect(find('#category_101-01')).to be_checked

    uncheck 'category_101'
    click_button 'Save changes'

    expect(find('#category_101')).to_not be_checked
  end

  scenario 'when going to the 3rd subcategory', :js do
    check 'category_101'
    check 'category_101-01'
    check 'category_101-02'
    check 'category_101-03'

    click_button 'Save changes'

    expect(find('#category_101-03')).to be_checked
    expect(find('#category_101-02')).to be_checked
    expect(find('#category_101-01')).to be_checked
    expect(find('#category_101')).to be_checked
  end
end
