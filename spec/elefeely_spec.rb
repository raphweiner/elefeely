require 'spec_helper'

describe Elefeely do
  context 'with an valid credentials' do
    it 'should be configurable' do
      expect {
        Elefeely.configure(source_key: '123', source_secret: 'abc')
        }.to_not raise_error
    end
  end

  context 'with invalid credentials' do
    it 'should raise argument error with no source_key' do
      expect {
        Elefeely.configure(source_key: nil, source_secret: 'abc')
        }.to raise_error InvalidCredentials
    end

    it 'should raise argument error with no source_secret' do
      expect {
        Elefeely.configure(source_key: '123', source_secret: nil)
        }.to raise_error InvalidCredentials
    end
  end

  describe '.phone_numbers' do
    before(:all) do
      response = OpenStruct.new(code: 200, body: ({'hello' => 'json'}).to_json)
      Typhoeus.stub(/phones?/).and_return(response)
    end

    context 'with valid credentials' do
      before(:each) do
        Elefeely.stub(:source_key).and_return('123')
        Elefeely.stub(:source_secret).and_return('123')
      end

      it 'should return phone_numbers' do
        expect(Elefeely.phone_numbers).to eq ({'hello' => 'json'})
      end
    end

    context 'without credentials' do
      it 'should raise a type error' do
        expect { Elefeely.phone_numbers }.to raise_error InvalidCredentials
      end
    end
  end

  describe '.send_feeling' do
    context 'with valid credentials' do
      before(:all) do
        Elefeely.stub(source_key: '123', source_secret: '123')
        response = OpenStruct.new(code: 200, body: {'hello' => 'json'}.to_json)
        Typhoeus.stub(/feelings?/).and_return(response)
      end

      it 'should return response' do
        expect(Elefeely.send_feeling(hi: 'hi back')).to eq('hello' => 'json')
      end
    end

    context 'without credentials' do
      it 'should raise a type error' do
        expect { Elefeely.send_feeling(hi: 'hi back') }.to raise_error InvalidCredentials
      end
    end
  end

  describe '.verify_number' do
    context 'with valid credentials' do
      before(:each) do
        Elefeely.stub(source_key: '123', source_secret: '123')
        response = OpenStruct.new(code: 200, body: {'hello' => 'json'}.to_json)
        Typhoeus.stub(/phones/ => response)
      end

      context 'and phone number' do
        it 'should return a response' do
          expect(Elefeely.verify_number('1234567890')).to eq('hello' => 'json')
        end
      end

      context 'without a phone number' do
        it 'should not raise an argument error' do
          expect(Elefeely.verify_number(nil)).to_not raise_error InvalidCredentials
        end
      end
    end

    context 'without credentials' do
      it 'should raise argument error' do
        expect { Elefeely.verify_number('1234567890') }.to raise_error InvalidCredentials
      end
    end
  end

  describe '.unsubscribe_number' do
      before(:each) do
        Elefeely.stub(source_key: '123', source_secret: '123')
        response = OpenStruct.new(code: 200, body: {'hello' => 'json'}.to_json)
        Typhoeus.stub(/phones/ => response)
      end

    context 'with valid credentials' do
      it 'should return a response' do
        expect(Elefeely.unsubscribe_number('1234567890')).to eq('hello' => 'json')
      end
    end
  end
end
