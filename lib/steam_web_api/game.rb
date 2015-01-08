module SteamWebApi

	class Game < Base

		attr_reader :game_id

		def initialize(game_id)
			@game_id = game_id	
		end
		
		class << self

			def all
				response = Faraday.get('http://api.steampowered.com/ISteamApps/GetAppList/v0002/')
				return response.status == 200 ? JSON.parse(response.body)['applist']['apps']: []
			end

		end

		def schema
			response = get('/ISteamUserStats/GetSchemaForGame/v2', appid: game_id, key: SteamWebApi.config.api_key)
			if response.status === 200
				data = JSON.parse(response.body)['game']
				OpenStruct.new(name: data['gameName'], version: data['gameVersion'], achievements: data['availableGameStats']['achievements'], stats: data['availableGameStats']['stats'], success: true)
			else
				OpenStruct.new(name: nil, version: nil, achievements: [], success: false)
			end	
		end

	end
	
end