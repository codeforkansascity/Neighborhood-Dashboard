require "rails_helper"

RSpec.describe Neighborhood::CrimeData do
  let (:coordinates) {
    [
      double(latitude: 24, longtitude: 24),
      double(latitude: 24, longtitude: 25),
      double(latitude: 24, longtitude: 26),
      double(latitude: 24, longtitude: 27)
    ]
  }

  let(:neighborhood) { double(name: 'Test', id: 24, coordinates: coordinates) }
  let(:subject) { Neighborhood::CrimeData.new(neighborhood) }
  let(:base_url) {
    Neighborhood::CrimeData::RESOURCE_URL
  }

  let(:service_response) {
    [
      {
        "address" => "1100  LOCUST ST",
        "area_1" => "CPD","beat":"142",
        "city" => "KANSAS CITY",
        "description" => "Misc Violation",
        "dvflag_1" => "U",
        "firearm_used_flag" => "N",
        "from_date" => "2014-07-28T00:00:00.000",
        "from_time" => "17:15",
        "ibrs" => "90Z",
        "invl_no_1" => "1",
        "involvement_1" => "SUS",
        "location_1" =>
          {
            "type" => "Point",
            "coordinates" => [-94.577375,39.100855]
          },
        "location_1_location" => "1100 LOCUST ST",
        "offense" => "2601",
        "race_1" => "U",
        "rep_dist_1" => "PJ1029",
        "report_no" => "140052949",
        "reported_date" => "2014-07-28T00:00:00.000",
        "reported_time" => "17:15",
        "sex_1" => "U",
        "zip_code_1" => "64106"
      },
      {
        "address" => "5500-BLK PASEO",
        "area_1" => "MPD",
        "beat" => "221",
        "city" => "KANSAS CITY",
        "description" => "Auto Theft",
        "dvflag_1" => "U",
        "firearm_used_flag" => "N",
        "from_date" => "2014-07-25T00:00:00.000",
        "from_time" => "13:00",
        "ibrs" => "240",
        "invl_no_1" => "1",
        "involvement_1" => "SUS",
        "location_1" =>
          {
            "type" => "Point",
            "coordinates" => [-94.573217,39.035988]
          },
        "location_1_location" => "5500-BLK PASEO",
        "offense" => "702",
        "race_1" => "B",
        "rep_dist_1" => "PJ4422",
        "report_no" => "140052108",
        "reported_date" => "2014-07-25T00:00:00.000",
        "reported_time" => "13:07",
        "sex_1" => "M",
        "zip_code_1" => "64110"
      }
    ]
  }

  let (:expected_coordinates) {
    [
      {
        "ibrs" => "90Z",
        "type" => "Feature",
        "geometry" => {
          "type" => "Point",
          "coordinates" => [-94.577375,39.100855]
        },
        "properties" => {
          "color" => "#ffffff",
          "disclosure_attributes" => ["Misc Violation\u003cbr/\u003e07/28/2014"]
        }
      },
      {
        "ibrs" => "240",
        "type" => "Feature",
        "geometry" => {
          "type" => "Point",
          "coordinates" => [-94.573217,39.035988]
        },
        "properties" => {
          "color" => "#313945",
          "disclosure_attributes" => ["Auto Theft\u003cbr/\u003e07/25/2014"]
        }
      }
    ]
  }

  describe "#map_coordinates" do
    context 'when the user passes empty parameters to the mapping coordinates' do
      let(:expected_service_url) {
        coordinates = neighborhood.coordinates.map { |coordinate|
          "#{coordinate.longtitude} #{coordinate.latitude}"
        }.join(',')

        base_url + "?$where=within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')"
      }

      before do
        allow(URI).to receive(:escape).and_return('compiled_url')

        allow(HTTParty).to receive(:get).with('compiled_url', {verify: false})
          .and_return(service_response)
      end

      it 'hits the correct service endpoints' do
        subject.map_coordinates({})
        expect(URI).to have_received(:escape).with(expected_service_url)
      end

      it 'returns the coordinates mapped in the correct structure' do
        expect(subject.map_coordinates({})).to eq(expected_coordinates)
      end
    end

    context 'when the user passes in a start and end date in the parameters' do
      let(:start_date) { 'Thu Mar 03 2016 00:00:00 GMT-0600 (CST)' }
      let(:end_date) { 'Fri Mar 25 2016 00:00:00 GMT-0500 (CDT)' }

      let(:expected_service_url) {
        coordinates = neighborhood.coordinates.map { |coordinate|
          "#{coordinate.longtitude} #{coordinate.latitude}"
        }.join(',')

        base_url +
          "?$where=within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')" +
          " AND from_date between '#{DateTime.parse(start_date).iso8601[0...-6]}' and '#{DateTime.parse(end_date).iso8601[0...-6]}'"

      }

      before do
        allow(URI).to receive(:escape).and_return('compiled_url')

        allow(HTTParty).to receive(:get).with('compiled_url', {verify: false})
          .and_return(service_response)
      end

      it 'hits the correct service endpoints' do
        subject.map_coordinates({start_date: start_date, end_date: end_date})
        expect(URI).to have_received(:escape).with(expected_service_url)
      end

      it 'returns the coordinates mapped in the correct structure' do
        expect(subject.map_coordinates({start_date: start_date, end_date: end_date})).to eq(expected_coordinates)
      end
    end

    context 'when the user passes in crime codes' do
      let(:crime_codes) { ['10', '20', '30', '40', '50A'] }

      let(:expected_service_url) {
        coordinates = neighborhood.coordinates.map { |coordinate|
          "#{coordinate.longtitude} #{coordinate.latitude}"
        }.join(',')

        crime_filters = crime_codes.join("' OR ibrs='")

        base_url +
          "?$where=within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')" +
          " AND (ibrs = '#{crime_filters}')"
      }

      before do
        allow(URI).to receive(:escape).and_return('compiled_url')

        allow(HTTParty).to receive(:get).with('compiled_url', {verify: false})
          .and_return(service_response)
      end

      it 'hits the correct service endpoints' do
        subject.map_coordinates({crime_codes: crime_codes})
        expect(URI).to have_received(:escape).with(expected_service_url)
      end

      it 'returns the coordinates mapped in the correct structure' do
        expect(subject.map_coordinates({crime_codes: crime_codes})).to eq(expected_coordinates)
      end
    end
  end
end
