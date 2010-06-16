Spec::Matchers.define :contain do |element|
  match do |container|
    container.include? element
  end
  
  failure_message_for_should do |container|
    "expected #{element.inspect} to be in #{container.inspect}"
  end
  
  failure_message_for_should_not do |container|
    "expected #{element.inspect} not to be in #{container.inspect}"
  end
end
