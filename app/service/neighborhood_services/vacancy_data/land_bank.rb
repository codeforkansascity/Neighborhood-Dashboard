require 'socrata_client'

class NeighborhoodServices::VacancyData::LandBank
  DATA_SOURCE = '2ebw-sp7f'
  API_SOURCE = 'n653-v74j'

  DATA_SOURCE_URI = 'https://data.kcmo.org/Property/Land-Bank-Data/2ebw-sp7f'
  POSSIBLE_FILTERS = ['foreclosed', 'demo_needed', 'landbank_vacant_lots', 'landbank_vacant_structures']

  def initialize(neighborhood, vacant_filters = {})
    @neighborhood = neighborhood
    @vacant_filters = vacant_filters[:filters] || []
    @start_date = vacant_filters[:start_date]
    @end_date = vacant_filters[:end_date]
  end

  def data
    parcel_data_set = ::KcmoDatasets::LandBankData.new(@neighborhood)
    parcel_data_set.filters = {
      data_filters: @vacant_filters,
      start_date: @start_date,
      end_date: @end_date
    }

    parcel_data = parcel_data_set.request_data

    @data = land_bank_filtered_data(parcel_data)
      .values
      .each { |violation| 
        violation.metadata = parcel_data_set.metadata
      }
      .select(&Entities::GeoJson::MAPPABLE_ITEMS)

    @data
  end

  private

  def land_bank_filtered_data(parcel_data)
    land_bank_filtered_data = {}

    if @vacant_filters.include?('foreclosed')
      foreclosure_data = ::NeighborhoodServices::VacancyData::Filters::Foreclosure.new(parcel_data).filtered_data
      foreclosure_data_entities = foreclosure_data.map{ |land_bank| ::Entities::LandBankData::Foreclosure.deserialize(land_bank) }
      merge_data_set(land_bank_filtered_data, foreclosure_data_entities)
    end

    if @vacant_filters.include?('demo_needed')
      demo_needed_data = ::NeighborhoodServices::VacancyData::Filters::DemoNeeded.new(parcel_data).filtered_data
      demo_needed_data_entities = demo_needed_data.map{ |land_bank| ::Entities::LandBankData::DemoNeeded.deserialize(land_bank) }
      merge_data_set(land_bank_filtered_data, demo_needed_data_entities)
    end

    if @vacant_filters.include?('landbank_vacant_lots') || @vacant_filters.include?('landbank_vacant_structures')
      all_vacant_lots_data_entities = parcel_data.map{ |land_bank| ::Entities::LandBankData::LandBank.deserialize(land_bank) }
      merge_data_set(land_bank_filtered_data, all_vacant_lots_data_entities)
    end

    land_bank_filtered_data
  end

  def merge_data_set(data, data_set)
    data_set.each do |entity|
      data[entity.parcel_number] = Entities::LandBankData::LandBanks.new(entity.data_hash) unless data[entity.parcel_number]
      data[entity.parcel_number].add_dataset(entity)
    end
  end
end
