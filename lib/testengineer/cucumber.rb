Around('@testengineer') do |scenario, block|
  start_stack
  begin
    block.call
  ensure
    stop_stack
  end
end
