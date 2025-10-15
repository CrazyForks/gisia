json.extract! @response, :reference_counter_decreased
json.messages @response[:messages] do |message|
  json.message message[:message]
  json.type message[:type]
end

