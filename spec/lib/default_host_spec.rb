require 'rails_helper'

describe DefaultHost do
  describe '#call' do
    context 'heroku domain' do
      it 'only allows the configured domain name' do
        allow(Figaro.env).to receive(:domain_name).and_return('app.herokuapp.com')
        request = double(host: 'foo.herokuapp.com')

        expect(DefaultHost.new.call(request)).to eq 'app.herokuapp.com'
      end
    end

    context 'custom domain with subdomain' do
      it 'uses the full domain with subdomain' do
        request = double(host: 'foo.example.com')

        expect(DefaultHost.new.call(request)).to eq 'foo.example.com'
      end
    end

    context 'custom domain but domain_name is not set to naked domain' do
      it 'will not redirect properly to subdomains' do
        allow(Figaro.env).to receive(:domain_name).and_return('www.example.com')
        request = double(host: 'admin.example.com')

        expect(DefaultHost.new.call(request)).to eq 'www.example.com'
      end
    end

    context 'unauthorized host' do
      it 'returns the configured domain name' do
        request = double(host: 'test.com')

        expect(DefaultHost.new.call(request)).to eq 'example.com'
      end
    end
  end
end
