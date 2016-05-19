class FetchManifestJob < ActiveJob::Base
  require 'faraday'
  require 'zip'

  queue_as :default

  URL = 'http://www.bungie.net'

  def perform(api_key = nil)
    @api_key = ENV['BUNGIE_API_KEY'] || api_key
    @connection = Faraday.new url: URL

    raise "Invalid api key" if @api_key.nil?

    zipfile = download_file(database_url)
    file = extract_file(zipfile)

    puts file
  end

  private

    def database_url
      response = @connection.get do |req|
        req.url '/Platform/Destiny/Manifest/'
        req.headers['X-API-Key'] = @api_key
      end

      json = JSON.parse response.body
      json["Response"]["mobileWorldContentPaths"]["en"]
    end

    def download_file(file)
      puts "Downloading.."

      response = @connection.get do |req|
        req.url file
        req.headers['X-API-Key'] = @api_key
      end

      filename = temp_file(:zip)

      File.open(filename, 'wb') do |fp|
        fp.write(response.body)
      end

      filename
    end

    def extract_file(file)
      puts "Extracting.."

      filename = temp_file(:db)
      Zip::File.open(file) { |zip_file| zip_file.first.extract(filename) }

      File.delete(file)
      filename
    end

    def temp_file(extension)
      t = Tempfile.new(['database', ".#{extension}"])
      temp_file = t.path
      t.close
      t.unlink

      temp_file
    end
end
