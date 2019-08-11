require 'spec_helper'

feature 'External request' do
  it 'queries FactoryGirl contributors on GitHub' do
    uri = URI('https://api.github.com/repos/thoughtbot/factory_girl/contributors')

    expect { Net::HTTP.get(uri) }.to raise_error
  end
end