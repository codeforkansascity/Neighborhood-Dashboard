require 'rails_helper'

RSpec.describe VacancyPdfExport do
  subject{ VacancyPdfExport.new(neighborhood, data_points)}

  let(:neighborhood) { double }
  let(:data_points) { 
    (VacancyPdfExport::ALPHANUMERIC_CHARS.size * VacancyPdfExport::COLORS.size).times.map{ |value| value }
  }

  describe '#markers' do
    it 'sets the correct label and color based on the array position for markers 0-34' do
      expect(subject.markers[0][:label]).to eq('1')
      expect(subject.markers[0][:color]).to eq('6B2C00')
      expect(subject.markers[0][:data]).to eq(0)

      expect(subject.markers[34][:label]).to eq('Z')
      expect(subject.markers[34][:color]).to eq('6B2C00')
      expect(subject.markers[34][:data]).to eq(34)
    end

    it 'sets the correct label and color based on the array position for markers 35-69' do
      expect(subject.markers[35][:label]).to eq('1')
      expect(subject.markers[35][:color]).to eq('004200')
      expect(subject.markers[35][:data]).to eq(35)

      expect(subject.markers[69][:label]).to eq('Z')
      expect(subject.markers[69][:color]).to eq('004200')
      expect(subject.markers[69][:data]).to eq(69)
    end

    it 'sets the correct label and color based on the array position for markers 70-104' do
      expect(subject.markers[70][:label]).to eq('1')
      expect(subject.markers[70][:color]).to eq('3C0042')
      expect(subject.markers[70][:data]).to eq(70)

      expect(subject.markers[104][:label]).to eq('Z')
      expect(subject.markers[104][:color]).to eq('3C0042')
      expect(subject.markers[104][:data]).to eq(104)
    end

    it 'sets the correct label and color based on the array position for markers 105-139' do
      expect(subject.markers[105][:label]).to eq('1')
      expect(subject.markers[105][:color]).to eq('423000')
      expect(subject.markers[105][:data]).to eq(105)

      expect(subject.markers[139][:label]).to eq('Z')
      expect(subject.markers[139][:color]).to eq('423000')
      expect(subject.markers[139][:data]).to eq(139)
    end

    it 'sets the correct label and color based on the array position for markers 140-174' do
      expect(subject.markers[140][:label]).to eq('1')
      expect(subject.markers[140][:color]).to eq('010042')
      expect(subject.markers[140][:data]).to eq(140)

      expect(subject.markers[174][:label]).to eq('Z')
      expect(subject.markers[174][:color]).to eq('010042')
      expect(subject.markers[174][:data]).to eq(174)
    end

    it 'sets the correct label and color based on the array position for markers 175-209' do
      expect(subject.markers[175][:label]).to eq('1')
      expect(subject.markers[175][:color]).to eq('18181B')
      expect(subject.markers[175][:data]).to eq(175)

      expect(subject.markers[209][:label]).to eq('Z')
      expect(subject.markers[209][:color]).to eq('18181B')
      expect(subject.markers[209][:data]).to eq(209)
    end

    it 'sets the correct label and color based on the array position for markers 210-244' do
      expect(subject.markers[210][:label]).to eq('1')
      expect(subject.markers[210][:color]).to eq('422412')
      expect(subject.markers[210][:data]).to eq(210)

      expect(subject.markers[244][:label]).to eq('Z')
      expect(subject.markers[244][:color]).to eq('422412')
      expect(subject.markers[244][:data]).to eq(244)
    end

    it 'sets the correct label and color based on the array position for markers 245-279' do
      expect(subject.markers[245][:label]).to eq('1')
      expect(subject.markers[245][:color]).to eq('6B0000')
      expect(subject.markers[245][:data]).to eq(245)

      expect(subject.markers[279][:label]).to eq('Z')
      expect(subject.markers[279][:color]).to eq('6B0000')
      expect(subject.markers[279][:data]).to eq(279)
    end
  end
end
