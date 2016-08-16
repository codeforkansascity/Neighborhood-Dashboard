module SocrataClient
  CLIENT = SODA::Client.new(domain: 'data.kcmo.org')

  def self.get(source, query)
    puts "Sending the following to #{source}"
    puts "Sending #{query}"
    puts query
    CLIENT.get(source, '$query' => query)
  end
end