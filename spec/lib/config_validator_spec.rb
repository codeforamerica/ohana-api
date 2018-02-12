require 'rails_helper'

describe ConfigValidator do
  describe '#validate' do
    let(:invalid_env) do
      {
        'ASSET_HOST' => '',
        'DEFAULT_PER_PAGE' => '',
        'DOMAIN_NAME' => '',
        'MAX_PER_PAGE' => ''
      }
    end

    let(:valid_env) do
      {
        'ASSET_HOST' => 'lvh.me',
        'DEFAULT_PER_PAGE' => '30',
        'DOMAIN_NAME' => 'lvh.me',
        'MAX_PER_PAGE' => '30',
        'DEV_SUBDOMAIN' => ''
      }
    end

    it 'raises if one or more required key values is set to an empty string' do
      list = 'ASSET_HOST, DEFAULT_PER_PAGE, DOMAIN_NAME, MAX_PER_PAGE'

      expect { ConfigValidator.new(invalid_env).validate }.to raise_error(
        RuntimeError, "These configs are required but are empty: #{list}"
      )
    end

    it 'does not raise if a non-required key is empty' do
      expect { ConfigValidator.new(valid_env).validate }.to_not raise_error
    end
  end
end
