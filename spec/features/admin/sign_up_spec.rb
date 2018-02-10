require 'rails_helper'

feature 'Signing up for a new admin account' do
  scenario 'with all required fields present and valid' do
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(page).to have_content 'activate your account'
    expect(page).to have_content('Admin')
    expect(current_path).to eq(new_admin_session_path)
  end

  scenario 'with custom confirmation email address' do
    reset_email
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(first_email.from.first).to eq('registration@ohanapi.org')
  end

  scenario 'with custom mailer' do
    reset_email
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(first_email.body).to include('Admin')
    expect(first_email.body).to include('/admin')
    expect(first_email.body).to_not include('documentation')
  end

  scenario 'with name missing' do
    sign_up_admin('', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(page).to have_content "Name can't be blank"
  end

  scenario 'with email missing' do
    sign_up_admin('Moncef', '', 'ohanatest', 'ohanatest')
    expect(page).to have_content "Email can't be blank"
  end

  scenario 'with password missing' do
    sign_up_admin('Moncef', 'moncef@foo.com', '', 'ohanatest')
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'with password confirmation missing' do
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', '')
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario "when password and confirmation don't match" do
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohana')
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  context 'when signing up with existing email', email: true do
    before(:each) do
      sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
      sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    end

    def portal_name
      I18n.t('titles.admin', brand: I18n.t('titles.brand'))
    end

    it 'does not reveal that the email has already been taken' do
      expect(page).not_to have_content 'Email has already been taken'
    end

    it 'redirects back to admin portal sign in page' do
      expect(current_path).to eq new_admin_session_path
    end

    it 'sends an email to the user informing them of sign up' do
      expect(last_email.body).to include 'email address is already in use'
    end

    it 'mentions the admin portal' do
      expect(last_email.body).to include portal_name
    end

    it 'links to the admin sign in page' do
      expect(last_email.body).to have_link new_admin_session_path
    end

    it 'links to the admin sign up page' do
      expect(last_email.body).
        to have_link 'sign up', href: 'http://example.com/admin/sign_up'
    end

    it 'links to the admin reset password page' do
      expect(last_email.body).
        to have_link 'resetting your password', href: 'http://example.com/admin/password/new'
    end

    it 'mentions the admin portal in the email subject' do
      expect(last_email.subject).to eq "Request to sign up on #{portal_name}"
    end
  end

  describe 'duplicate email along with other validation errors' do
    shared_examples 'does not reveal existing email' do
      it 'does not display duplicate email error' do
        expect(page).not_to have_content 'Email has already been taken'
      end

      it 'does not send an email', email: true do
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context 'when duplicate email and name is missing during sign up' do
      before(:each) do
        sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
        sign_up_admin('', 'moncef@foo.com', 'ohanatest', 'ohanatest')
      end

      it_behaves_like 'does not reveal existing email'
    end

    context 'when duplicate email and password is missing during sign up' do
      before(:each) do
        sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
        sign_up_admin('', 'moncef@foo.com', '', 'ohanatest')
      end

      it_behaves_like 'does not reveal existing email'
    end

    context 'when duplicate email and password_confirmation invalid during sign up' do
      before(:each) do
        sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
        sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', '')
      end

      it_behaves_like 'does not reveal existing email'
    end

    context 'when duplicate email and password is too short during sign up' do
      before(:each) do
        sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
        sign_up_admin('Moncef', 'moncef@foo.com', 'foo', 'foo')
      end

      it_behaves_like 'does not reveal existing email'
    end
  end
end
