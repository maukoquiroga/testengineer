require 'spec_helper'

describe TestEngineer do
  let(:foreman) { double('Foreman::Engine') }

  describe '#foreman' do
    it 'should return nil when $foreman is nil' do
      subject.foreman.should be nil
    end

    it 'return the value in $foreman' do
      $foreman = foreman
      subject.foreman.should be $foreman
    end

    after :each do
      $foreman = nil
    end
  end

  describe '#wait_for_socket' do
  end

  describe '#stop_process' do
  end

  describe '#start_stack' do
  end

  describe '#stop_stack' do
    it 'should not do anything if foreman is nil' do
      foreman.should_not_receive(:terminate_gracefully)
      subject.stub(:foreman).and_return(nil)
      subject.stop_stack
    end

    it 'should invoke #terminate_gracefully if foreman exists' do
      foreman.should_receive(:terminate_gracefully)
      subject.stub(:foreman).and_return(foreman)
      subject.stop_stack
    end
  end
end
