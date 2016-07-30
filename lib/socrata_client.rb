module SocrataClient
  CLIENT = SODA::Client.new(domain: 'data.kcmo.org')

  def self.get(source, query)
    CLIENT.get(source, '$query' => query)
  end
end