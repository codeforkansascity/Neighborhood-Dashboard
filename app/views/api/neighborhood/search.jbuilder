json.array! @neighborhoods do |neighborhood|
  json.id neighborhood.id
  json.text neighborhood.name
end
