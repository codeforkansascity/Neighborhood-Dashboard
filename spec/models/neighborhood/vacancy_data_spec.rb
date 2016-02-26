require "rails_helper"

RSpec.describe Neighborhood::VacancyData do
  let (:coordinates) {
    [
      {latitude: 24, longtitude: 24},
      {latitude: 24, longtitude: 25},
      {latitude: 24, longtitude: 26},
      {latitude: 24, longtitude: 27}
    ]
  }

  let(:neighborhood) { double(name: 'Test', id: 24, coordinates: coordinates) }
  subject { Neighborhood::VacancyData.new(neighborhood) }

  describe "#legally_abandoned" do
    let(:building_1) {
      [
        {
          "id" => "1",
          "violation_code" => "NSVACANT",
          "mapping_location" => {
            "human_address" => "5616 GARFIELD AVE"
          }
        },
        {
          "id" => "1",
          "violation_code" => "NSWEEDS",
          "mapping_location" => {
            "human_address" => "5616 GARFIELD AVE"
          }
        }
      ]
    }

    let(:building_2) {
      [
        {
          "id" => "1",
          "violation_code" => "NSVACANT",
          "mapping_location" => {
            "human_address" => "1814 E 49TH ST"
          }
        },
        {
          "id" => "1",
          "violation_code" => "NSBOARD01",
          "mapping_location" => {
            "human_address" => "1814 E 49TH ST"
          }
        }
      ]
    }

    let (:building_3) {
      [
        {
          "id" => "1",
          "violation_code" => "NSBOARD01",
          "mapping_location" => {
            "human_address" => "2026 E 48TH TER"
          }
        },
        {
          "id" => "1",
          "violation_code" => "NSWEEDS",
          "mapping_location" => {
            "human_address" => "2026 E 48TH TER"
          }
        }
      ]
    }

    let(:building_4) {
      [
        {
          "id" => "1",
          "violation_code" => "NSBOARD01",
          "mapping_location" => {
            "human_address" => "5515 BROOKLYN AVE"
          }
        },
        {
          "id" => "1",
          "violation_code" => "NSVACANT",
          "mapping_location" => {
            "human_address" => "5515 BROOKLYN AVE"
          }
        }
      ]
    }

    let(:code_violations_data) { building_1 + building_2 + building_3 + building_4 }

    before do
      allow(HTTParty).to receive(:get)
        .and_return(code_violations_data)
    end

    context 'when a building has a code violation of NSVACANT' do
      context 'when a building has an additional code violation other than NSBOARD01' do
        it 'adds the building to the returned JSON' do
          expect(subject.legally_abandoned[building_1[0]['mapping_location']['human_address']]).to_not be_nil
        end
      end

      context 'when a building does not have an additional code violation other than NSBOARD01' do
        it 'does not adds the building to the returned JSON' do
          expect(subject.legally_abandoned[building_2[0]['mapping_location']['human_address']]).to be_nil
        end
      end
    end

    context 'when a building has a code violation of NSBOARD01' do
      context 'when a building has an additional code violation other than NSVACANT' do
        it 'adds the building to the returned JSON' do
          expect(subject.legally_abandoned[building_3[0]['mapping_location']['human_address']]).to_not be_nil
        end
      end

      context 'when a building does not have an additional code violation other than NSVACANT' do
        it 'does not adds the building to the returned JSON' do
          expect(subject.legally_abandoned[building_4[0]['mapping_location']['human_address']]).to be_nil
        end
      end
    end
  end
end