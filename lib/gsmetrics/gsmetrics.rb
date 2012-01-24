require 'builder'
require 'httparty'
require 'json'
require 'crack'

module GSMetrics
  class Session
    def initialize client_id, client_secret, refresh_token
      refresh_request = {
        :client_id => client_id,
        :client_secret => client_secret,
        :refresh_token => refresh_token,
        :grant_type => "refresh_token"
      }
      response = HTTParty.post("https://accounts.google.com/o/oauth2/token", :body => refresh_request)
      parsed = JSON.parse(response.body)
      @access_token = parsed["access_token"]
    end

    def worksheet doc_id, worksheet_id
      Worksheet.new doc_id, worksheet_id, @access_token
    end
  end

private
  class Worksheet
    attr_accessor :check_worksheet_size
    def initialize doc_id, worksheet_id, access_token
      @check_worksheet_size = true
      @doc_id = doc_id
      @worksheet_id = worksheet_id
      @access_token = access_token
      @items = []
      @worksheet_cell_href = "https://spreadsheets.google.com/feeds/cells/#{@doc_id}/#{@worksheet_id}/private/full"
      @worksheet_href= "https://spreadsheets.google.com/feeds/list/#{@doc_id}/#{@worksheet_id}/private/full"

      @query = {"access_token" => @access_token, :v => "3.0"}
      @headers = {"Content-Type" => "application/atom+xml", "If-Match" => "*"}
    end

    def append item
      @items << item
    end

    def << item
      append item
    end

    def save_row row_id = nil
      xmlns = {:xmlns => "http://www.w3.org/2005/Atom",
          "xmlns:batch" => "http://schemas.google.com/gdata/batch",
          "xmlns:gs" => "http://schemas.google.com/spreadsheets/2006"}

      response = HTTParty.get(@worksheet_href, :query => @query)

      row_id ||= parse(response.body)["feed"]["openSearch:totalResults"].to_i + 2

      set_worksheet_size row_id if @check_worksheet_size

      xml = builder.feed(xmlns) do |build|
        build.id("#{@worksheet_cell_href}")
        @items.each_with_index{|item, index|
          col_index = index+1
          col_id = "R#{row_id}C#{col_index}"
          col_href="#{@worksheet_cell_href}/#{col_id}"
          build.entry { |b|
              b.send("batch:id", "A#{index}")
              b.send("batch:operation", :type => "update")
              b.id(col_href)
              b.link(:rel => "edit", :type => "application/atom+xml", :href => col_href)
              b.send("gs:cell", :row => row_id, :col => col_index, :inputValue => item)
            }
        }
      end
      response = HTTParty.post("#{@worksheet_cell_href}/batch", :headers => @headers, :query => @query, :body => xml)
      raise Exception if response.code != 200
      @items = []
    end

    def set_worksheet_size row_id
      href = "https://spreadsheets.google.com/feeds/worksheets/#{@doc_id}/private/full/#{@worksheet_id}"
      worksheet = parse(HTTParty.get(href, :query => @query))
      row_count = worksheet["entry"]["gs:rowCount"].to_i

      update_href = worksheet["entry"]["link"].last["href"]

      add = builder.entry(:xmlns => "http://www.w3.org/2005/Atom", "xmlns:gs" => "http://schemas.google.com/spreadsheets/2006"){|e|
        e.send("gs:rowCount", row_id)
        e.send("gs:colCount", worksheet["entry"]["gs:colCount"].to_i)
        e.title(worksheet["entry"]["title"])
      }
      HTTParty.put(update_href, :query => @query, :headers => @headers, :body => add) if row_count < row_id
    end

    def parse content
      Crack::XML.parse(content)
    end

    def alphabet
      ("A".."ZZ").to_a
    end

    def builder
      Builder::XmlMarkup.new
    end
  end
end