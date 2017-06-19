module Utilities::AttributesList
  def attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  def attributes
    @attributes
  end
end
