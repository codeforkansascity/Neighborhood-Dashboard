module Entities::LandBankData
  class Foreclosure < LandBank
    attr_accessor :foreclosure_year

    def disclosure_attributes
      ["<b>Foreclosure Year:</b> #{land_bank['foreclosure_year']}"]
    end
  end
end
