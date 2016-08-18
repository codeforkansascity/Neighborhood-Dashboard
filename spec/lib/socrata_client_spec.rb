require 'socrata_client'

RSpec.describe SocrataClient do
  describe '.get' do
    before do
      allow(SocrataClient::CLIENT).to receive(:get)
    end

    it 'sends the source and query to the client' do
      SocrataClient.get('test', 'SELECT *')

      expect(SocrataClient::CLIENT).to have_received(:get)
        .with('test', '$query' => 'SELECT *')
    end
  end
end