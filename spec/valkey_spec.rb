require 'rails_helper'

RSpec.describe do
  describe "valkey set up as drop-in replacement for redis" do
    it 'should set and get values to the valkey store' do
      string = Kredis.string "mystring"
      string.value = "hello world!"
      expect(string.value).to eq "hello world!"
    end
  end
end
