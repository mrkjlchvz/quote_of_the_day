class BibleGenerator
  ENDPOINT = "http://quotes.rest/bible/vod.json"

  def self.generate
    new.generate
  end

  def generate
    res = response
    return random_bible_verse unless res.code == "200"

    generate_bible_verse(res)
  end

  private

  def generate_bible_verse(response)
    quote_hash = JSON.parse(response.body)["contents"]

    chapter = quote_hash["chapter"]
    number = quote_hash["number"]
    book = quote_hash["book"]
    testament = quote_hash["testament"]
    verse = quote_hash["verse"]

    "#{book} #{chapter}:#{number} (#{testament}) \n\n \"#{verse}\""
  end

  def random_bible_verse
    [
      "Proverbs 24:33-34 (NIV) \n\n \"A little sleep, a little slumber, a little folding of the hands to rest -- and poverty will come on you like a thief and scarcity like an armed man.\""
    ].sample
  end

  def response
    uri = URI.parse(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))

    response
  end
end
