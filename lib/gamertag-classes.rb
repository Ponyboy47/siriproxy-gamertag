require 'net/http'
require 'json'

class Profile

  def initialize(gamertag)
    @profile = fetch(gamertag)
  end

  def self.from_json(data)
    data = JSON.parse(data)
    new(data['Data'], data)
  end

  def method_missing(method_name, args = nil)
    @profile[method_name.to_s]
  end

  def tier
    tier = @profile['Tier']
    tier[0].to_upcase
    return tier
  end

  def is_cheater
    if @profile['IsCheater'] == 0
      return false
    else
      return true
    end
  end

  def is_online
    if @profile['IsOnline'] == 0
      online = [false, @profile['OnlineStatus']]
      return online
    else
      online = [true, @profile['OnlineStatus']]
      return online
    end
  end

  def avatars
    avatars = {'Tile' => @profile['AvatarTile'], 'Small' => @profile['AvatarSmall'], 'Large' => @profile['AvatarLarge'], 'Body' => @profile['AvatarBody']}
    return avatars
  end
end


class Friends

  def initialize(gamertag)
    @friends = fetch(gamertag)
  end

  def self.from_json(data)
    data = JSON.parse(data)
    new(data['Data'], data)
  end

  def method_missing(method_name, args = nil)
    @friends[method_name.to_s]
  end

  def friends
    @all_friends = []
    x = 0
    @friends['Friends'].each do |friend|
      @all_friends[x] = Friend.new
      @all_friends[x].gamertag = friend['Gamertag']
      @all_friends[x].avatars = {'Small' => friend['AvatarSmall'], 'Large' => friend['AvatarLarge']}
      @all_friends[x].gamerscore = friend['Gamerscore']
      @all_friends[x].is_online = friend['IsOnline']
      @all_friends[x].last_online = friend['PresenceInfo']['LastOnline']
      @all_friends[x].online_status = friend['PresenceInfo']['OnlineStatus']
      @all_friends[x].game_title = friend['PresenceInfo']['Game']['Title']
      @all_friends[x].game_id = friend['PresenceInfo']['Game']['Id']
      @all_friends[x].game_url = friend['PresenceInfo']['Game']['Url']
    x = x+1
    end
    return @all_friends
  end
end


class Games

  def initialize(gamertag)
    @games = fetch(gamertag)
  end

  def self.from_json(data)
    data = JSON.parse(data)
    new(data['Data'], data)
  end

  def method_missing(method_name, args = nil)
    @games[method_name.to_s]
  end

  def played_games
    @played_games = []
    x = 0
    @games['PlayedGames'].each do |game|
      @played_games[x] = Game.new
      @played_games[x].id = game['Id']
      @played_games[x].title = game['Title']
      @played_games[x].url = game['Url']
      @played_games[x].art = {'BoxArt' => game['BoxArt'], 'LargeBoxArt' => game['LargeBoxArt']}
      @played_games[x].earned_gamerscore = game['EarnedGamerScore']
      @played_games[x].possible_gamerscore = game['PossibleGamerScore']
      @played_games[x].earned_achievements = game['EarnedAchievements']
      @played_games[x].possible_achievements = game['PossibleAchievements']
      @played_games[x].percentage_completed = game['PercentageCompleted']
      @played_games[x].last_played = game['LastPlayed']
      x = x+1
    end
    return @played_games
  end
end

module GamertagModule
end

class Game
  include GamertagModule
  attr_accessor :id, :title, :url, :art, :earned_gamerscore, :possible_gamerscore, :earned_achievements, :possible_achievements, :percentage_completed, :last_played

  def id=(value)
    @id = value
  end
  def title=(value)
    @title = value
  end
  def url=(value)
    @url = value
  end
  def art=(value)
    @art = value
  end
  def earned_gamerscore=(value)
    @earned_gamerscore = value
  end
  def possible_gamerscore=(value)
    @possible_gamerscore = value
  end
  def earned_achievements=(value)
    @earned_achievements = value
  end
  def possible_achievements=(value)
    @possible_achievements = value
  end
  def percentage_completed=(value)
    @percentage_completed = value
  end
  def last_played=(value)
    @last_played = value
  end
end

class Friend
  include GamertagModule
  attr_accessor :gamertag, :avatars, :gamerscore, :is_online, :last_online, :online_status, :game_title, :game_id, :game_url

  def gamertag=(value)
    @gamertag = value
  end
  def avatars=(value)
    @avatars = value
  end
  def gamerscore=(value)
    @gamerscore = value
  end
  def is_online=(value)
    @is_online = value
  end
  def presence_info=(value)
    @presence_info = value
  end
  def last_online=(value)
    @last_online = value
  end
  def online_status=(value)
    @online_status = value
  end
  def game_title=(value)
    @game_title = value
  end
  def game_id=(value)
    @game_id = value
  end
  def game_url=(value)
    @game_url = value
  end
end
