require 'roo'

task :build_census_json, [:census_spreadsheet] do |t, args|
  spreadsheet = Roo::Spreadsheet.open(args[:census_spreadsheet])

  columns = spreadsheet.row(1).each_with_object({}).with_index do |(header, hash), index|
    hash[index + 1] = header.strip.gsub(/[,\s-]/, '_').downcase
  end

  data_hash = (2...spreadsheet.last_row).each_with_object({}) do |current_row, data_hash|
    neighborhood = spreadsheet.cell(current_row, 2)
    data_hash[neighborhood] = {}

    (3...spreadsheet.last_column).each do |current_column|
      data_hash[neighborhood][columns[current_column]] = spreadsheet.cell(current_row, current_column)
    end
  end

  File.open("data_sets/census_data.json", "w") do |f|
    f.write(data_hash.to_json)
  end

  puts 'Census Data Written Successfully'
end