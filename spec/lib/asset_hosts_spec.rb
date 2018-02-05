require 'rails_helper'

describe AssetHosts do
  describe '#call' do
    let(:request_with_port) { double(host: 'example.com', port: '3000') }
    let(:request_with_subdomain_and_port) do
      double(host: 'admin.example.com', port: '3000')
    end
    let(:request) { double(host: 'example.com', port: nil) }
    let(:request_with_unauthorized_host) do
      double(host: 'evil.example.com.evil.com', port: nil)
    end
    let(:request_without_port) do
      double(host: 'admin.example.com', port: nil)
    end

    context 'heroku domain' do
      it 'only allows the configured asset host' do
        allow(Figaro.env).to receive(:asset_host).and_return('app.herokuapp.com')
        request = double(host: 'foo.herokuapp.com', port: nil)

        expect(AssetHosts.new.call('image.png', request)).to eq 'app.herokuapp.com'
      end
    end

    context 'port but no subdomains' do
      it 'returns host with port' do
        expect(AssetHosts.new.call('image.png', request_with_port)).to eq 'example.com:3000'
      end
    end

    context 'subdomain with port' do
      it 'returns the host with subdomain and port' do
        expect(AssetHosts.new.call('image.png', request_with_subdomain_and_port)).
          to eq 'admin.example.com:3000'
      end
    end

    context 'no subdomains, no port' do
      it 'returns the host' do
        expect(AssetHosts.new.call('image.png', request)).to eq 'example.com'
      end
    end

    context 'unauthorized host' do
      it 'returns the default asset host' do
        expect(AssetHosts.new.call('image.png', request_with_unauthorized_host)).
          to eq 'example.com'
      end
    end

    context 'subdomain, no port' do
      it 'returns the host' do
        expect(AssetHosts.new.call('image.png', request_without_port)).to eq 'admin.example.com'
      end
    end

    context 'custom domain but asset host is not set to naked domain' do
      it 'will use asset_host' do
        allow(Figaro.env).to receive(:asset_host).and_return('www.example.com')
        request = double(host: 'example.com', port: nil)

        expect(AssetHosts.new.call('image.png', request)).to eq 'www.example.com'
      end
    end

    context 'request made from subdomain but asset host is not set to naked domain' do
      it 'will use asset_host' do
        allow(Figaro.env).to receive(:asset_host).and_return('www.example.com')
        request = double(host: 'admin.example.com', port: nil)

        expect(AssetHosts.new.call('image.png', request)).to eq 'www.example.com'
      end
    end
  end
end
