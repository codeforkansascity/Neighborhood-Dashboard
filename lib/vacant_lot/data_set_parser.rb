module VacantLot
  class DataSetParser
    def initialize
    end

    def tables
      @tables ||= fetch_data
    end

    private

    def fetch_data
      tables = []

      uri = URI.parse('http://webfusion.kcmo.org/coldfusionapps/neighborhood/rentalreg/PropList.cfm')
      response = Net::HTTP.get_response(uri)

      data = Nokogiri::HTML(response.body)

      data_table = data.css('table')
      table_rows = data_table.css('tr')

      vacant_lot_count = table_rows.length
      current_vacant_lot_count = 0

      table_rows.each do |table_row|
        table_cells = table_row.css('td')

        if table_cells.length == 8
          tables << 
            {
              property_address: table_cells[1].text.gsub(/\s+/, ' '),
              contact_person: table_cells[2].text,
              contact_address: table_cells[3].text,
              contact_phone: table_cells[4].text,
              property_type: table_cells[5].text,
              registration_type: table_cells[6].text,
              last_verified: table_cells[7].text
            }
        end

        current_vacant_lot_count += 1
        puts "Loaded #{current_vacant_lot_count}/#{vacant_lot_count}"
      end

      tables
    end
  end
end
