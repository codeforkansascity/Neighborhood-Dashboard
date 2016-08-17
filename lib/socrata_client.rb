module SocrataClient
  CLIENT = SODA::Client.new(domain: 'data.kcmo.org', ignore_ssl: true)

  def self.get(source, query)
    puts "Sending the following to #{source}"
    puts "Sending #{query}"
    CLIENT.get(source, '$query' => query)
  end
end