require 'roo'

task :build_census_json, [:census_spreadsheet, :year] do |t, args|
  spreadsheet = Roo::Spreadsheet.open(args[:census_spreadsheet])

  if File.exists?("data_sets/census_data.json")
    data_hash = JSON.parse(IO.read("data_sets/census_data.json"))
  else
    data_hash = {}
  end

  columns = spreadsheet.row(1).each_with_object({}).with_index do |(header, hash), index|
    hash[index + 1] = header.strip.gsub(/[,\s-]/, '_').downcase
  end

  (2...spreadsheet.last_row).each do |current_row|
    neighborhood = spreadsheet.cell(current_row, 2)

    if neighborhood.present?
      data_hash[neighborhood] = data_hash[neighborhood] || {}
      data_hash[neighborhood][args[:year]] = {}

      (3...spreadsheet.last_column).each do |current_column|
        data_hash[neighborhood][args[:year]][columns[current_column]] = spreadsheet.cell(current_row, current_column)
      end
    end
  end

  File.open("data_sets/census_data.json", "w") do |f|
    f.write(data_hash.to_json)
  end

  puts 'Census Data Written Successfully'
end
