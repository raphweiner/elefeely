require 'spec_helper'

describe Elefeely do
  context 'with an valid credentials' do
    it 'should be configurable' do
      expect {
        Elefeely.configure do |config|
          config.source_key = '123'
          config.source_secret = 'abc'
        end
        }.to_not raise_error
    end
  end

  context 'with invalid credentials' do
    it 'should raise argument error with no source_key' do
      expect {
        Elefeely.configure do |config|
          config.source_key = nil
          config.source_secret = 'abc'
        end
        }.to raise_error ArgumentError
    end

    it 'should raise argument error with no source_secret' do
      expect {
        Elefeely.configure do |config|
          config.source_key = '123'
          config.source_secret = nil
        end
        }.to raise_error ArgumentError
    end
  end

  describe '.phone_numbers' do
    context 'with valid credentials' do
      before(:each) do
        Elefeely.stub(:source_key).and_return('123')
        Elefeely.stub(:source_secret).and_return('123')
      end

      it 'should return phone_numbers' do
        response = OpenStruct.new(code: 200, body: ({'hello' => 'json'}).to_json)
        Typhoeus.stub(/phones?/).and_return(response)

        expect(Elefeely.phone_numbers).to eq ({'hello' => 'json'})
      end
    end

    context 'without credentials' do
      it 'should raise a type error' do
        response = OpenStruct.new(code: 200, body: ({'hello' => 'json'}).to_json)
        Typhoeus.stub(/phones?/).and_return(response)

        expect { Elefeely.phone_numbers }.to raise_error ArgumentError
      end
    end
  end

  describe '.send_feeling' do
    context 'with valid credentials' do
      before(:each) do
        Elefeely.stub(source_key: '123', source_secret: '123')
      end

      it 'should return response' do
        response = OpenStruct.new(code: 200, body: {'hello' => 'json'}.to_json)
        Typhoeus.stub(/feelings?/).and_return(response)

        expect(Elefeely.send_feeling(hi: 'hi back')).to eq('hello' => 'json')
      end
    end

    context 'without credentials' do
      it 'should raise a type error' do
        response = OpenStruct.new(code: 200, body: {'hello' => 'json'}.to_json)
        Typhoeus.stub(/feelings?/).and_return(response)

        expect { Elefeely.send_feeling(hi: 'hi back') }.to raise_error ArgumentError
      end
    end
  end

  describe '.verify_number' do
    context 'with valid credentials' do
      before(:each) do
        Elefeely.stub(source_key: '123', source_secret: '123')
      end

      context 'and a phone number' do
        it 'should return a response' do
          response = OpenStruct.new(code: 200, body: {'hello' => 'json'}.to_json)
          Typhoeus.stub(/phones/ => response)

          expect(Elefeely.verify_number('1234567890')).to eq('hello' => 'json')
        end
      end
    end

    context 'with invalid credentials' do
      it 'should raise argument error' do
        expect { Elefeely.verify_number('1234567890') }.to raise_error ArgumentError
      end
    end
  end
end
