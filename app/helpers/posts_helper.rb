module PostsHelper
  require 'net/http'
  require 'nokogiri'

  def find_next_siblings(doc, rtag, p) #jquery('base ~ next_siblings')
    res = []
    rchild = []
    m = false
    doc.children.each do |c|
      next if !c.is_a? Nokogiri::XML::Element
      m = true if c.name =~ rtag
      rchild |= find_next_siblings(c, rtag, p)
      res << c if m && c.name == p #TODO name_match
    end
    res | rchild
  end

  def parse_text_from_url url
    uri = URI.parse(url)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(Net::HTTP::Get.new(uri.path))
    end

    ts = []
    find_next_siblings(Nokogiri.parse(res.body), /h[1-6]/, 'p').each do |p|
      p.children.each do |e|
	next if !e.is_a? Nokogiri::XML::Text
	t = e.to_s.strip
	next if t.empty?
	ts << t
      end
    end
    ts[0..2].join(' ').sub(/[^\.]+$/,'')
  rescue
    logger.debug "parse_text_from_url: Exception: #{$!.inspect}"
    ''
  end
end

