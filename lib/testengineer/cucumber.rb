require 'testengineer'

Around('@testengineer') do |scenario, block|
  TestEngineer.start_stack
  begin
    block.call
  ensure
    TestEngineer.stop_stack
  end
end
