require 'spec_helper'
describe 'iis_vhost' do
  context 'with default values for all parameters' do
    it { should contain_class('iis_vhost') }
  end
end
