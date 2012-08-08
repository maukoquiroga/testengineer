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
    before :each do
      subject.stub(:foreman).and_return(foreman)
    end
    context 'no running processes' do
      before :each do
        foreman.stub(:running_processes).and_return([])
      end

      it 'do nothing and reset Foreman::Engine.terminating' do
        foreman.should_receive(:instance_variable_set).with(:@terminating, false)
        subject.stop_process('foreman')
      end

      it 'should raise an error on a nil name argument' do
        expect {
          subject.stop_process(nil)
        }.to raise_error
      end
    end
    context 'running processes' do
      let(:process) { double('Foreman::Process') }
      before :each do
        process.stub(:name).and_return('mock.1')
        foreman.stub(:running_processes).and_return([[1, process]])
      end

      it 'should not stop unmatched names' do
        process.should_not_receive(:kill)
        subject.stop_process('foreman')
      end

      it 'should not stop partially matched names' do
        process.should_not_receive(:kill)
        subject.stop_process('mockery')
      end

      it 'should stop matching named processes' do
        process.should_receive(:kill)
        Process.stub(:waitpid).and_return(true)
        subject.stop_process('mock')
      end
    end
  end

  describe '#start_stack' do
  end

  describe '#stop_stack' do
    it 'should not do anything if foreman is nil' do
      foreman.should_not_receive(:terminate_gracefully)
      subject.stub(:foreman).and_return(nil)
      subject.stop_stack
    end

    context 'with a stubbed foreman' do
      before :each do
        subject.stub(:foreman).and_return(foreman)
      end

      it 'should invoke #terminate_gracefully if foreman exists' do
        foreman.should_receive(:terminate_gracefully)
        subject.stop_stack
      end

      it 'should catch and hide ECHILD gracefully' do
        foreman.stub(:terminate_gracefully) do
          raise Errno::ECHILD
        end

        expect { subject.stop_stack }.not_to raise_error(Errno::ECHILD)
      end
    end

  end
end
