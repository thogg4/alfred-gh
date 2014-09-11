require 'alfred'

module AlfredGh

  def self.alfred_xml(query = '', items)
    document = REXML::Element.new("items")
    items.sort!

    if query.empty?
      items.each do |item|
        document << item.to_xml
      end
    else
      items.each do |item|
        document << item.to_xml if item.match?(query)
      end
      document << search_item(query).to_xml if !document.has_elements?
    end
    document.to_s
  end

  def self.search_item(query)
    opts = {
      uid: "",
      title: "Search Github for #{query}",
      subtitle: '',
      arg: "https://github.com/search?utf8=✓&q=#{query}"
    }
    Alfred::Feedback::Item.new(opts[:title], opts)
  end
    
end
