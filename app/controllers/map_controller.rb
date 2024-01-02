class MapController < ApplicationController
  def fetch_content
    require 'net/http'
    require 'json'

    api_key = '16673894-a144-46c9-b277-f1fb65ca43fb'

    url = URI.parse("https://api.openchargemap.io/v3/poi?key=#{api_key}")
    req = Net::HTTP::Get.new(url.to_s)

    begin
      res = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }

      if res.code.to_i == 200
        data = JSON.parse(res.body)

        address_infos = data.map { |item| item['AddressInfo'] }

        if address_infos.any?
          @address_infos = address_infos
          render 'address_infos'
        else
          render plain: 'AddressInfo not found in the response.'
        end
      else
        render plain: "Error: #{res.code} - #{res.message}"
      end
    rescue StandardError => e
      render plain: "Error: #{e.message}"
    end
  end
end