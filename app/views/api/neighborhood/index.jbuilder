json.array! @neighborhoods do |neighborhood|
  json.id neighborhood.id
  json.name neighborhood.name
  json.coordinates neighborhood.coordinates
end
