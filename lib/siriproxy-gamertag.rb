require 'cora'
require 'siri_objects'
require_relative 'gamertag-classes'

class SiriProxy::Plugin::Gamertag < SiriProxy::Plugin

  def initialize(config)
    if config['Gamertag']
      @myTag = config['Gamertag']
    else
      puts "[SiriProxy::Plugin::Gamertag] NO GAMERTAG SPECIFIED!"
      @myTag = nil
    end
#    setState(@myTag)
  end

  def setState(tag)
    if tag.nil?
      set_state nil
    else
      set_state :has_gamertag
    end
  end

  def makeName(tag)
    tag = tag.gsub(' ','+')
    tag[0] = tag[0].upcase
    return tag
  end
  
  listen_for /Gamer tag (.*)/i do |usertag|
    gamertag = makeName(usertag)
    profile = GamertagProfile.new("#{gamertag}")
    profileView = SiriAddViews.new
    profileView.make_root(last_ref_id)
    profileArray = []
    profileArray << SiriAnswerLine.new("Avatar","#{profile.avatars['Tile']}")
    profileArray << SiriAnswerLine.new("Name: #{profile.Name}") if profile.Name != ""
    profileArray << SiriAnswerLine.new("Motto: #{profile.Motto}") if profile.Motto != ""
    profileArray << SiriAnswerLine.new("Bio: #{profile.Bio}") if profile.Bio != ""
    profileArray << SiriAnswerLine.new("Location: #{profile.Location}") if profile.Location != ""
    profileArray << SiriAnswerLine.new("CHEATER! CHEATER! CHEATER!") if profile.is_cheater == true
    profileArray << SiriAnswerLine.new("#{profile.tier}")
    profileArray << SiriAnswerLine.new("CHEATER! CHEATER! CHEATER!") if profile.is_cheater == true
    say "#{profile.tier}"
    if profile.is_online[0] == false
      profileArray << SiriAnswerLine.new("Online Status: Offline, #{profile.is_online[1]}")
      say "Online Status: Offline, #{profile.is_online[1]}"
    else
      profileArray << SiriAnswerLine.new("Online Status: Online, #{profile.is_online[1]}")
      say "Online Status: Online, #{profile.is_online[1]}"
    end
    profileArray << SiriAnswerLine.new("CHEATER! CHEATER! CHEATER!") if profile.is_cheater == true
    profileArray << SiriAnswerLine.new("GamerScore: #{profile.GamerScore}")
    profileArray << SiriAnswerLine.new("CHEATER! CHEATER! CHEATER!") if profile.is_cheater == true
    profileArray << SiriAnswerLine.new("Reputation: #{profile.Reputation}")
    say "#{games.played_games[x].percentage_completed}"
    profileArray << SiriAnswerLine.new("CHEATER! CHEATER! CHEATER!") if profile.is_cheater == true
    profileAnswer = SiriAnswer.new("#{profile.Gamertag}", profileArray)
    profileView.views << SiriAnswerSnippet.new([profileAnswer])
    send_object profileView
  end
  
  listen_for /Recent games for (.*)/i do |usertag|
    gamertag = makeName(usertag)
    games = GamertagGames.new("#{gamertag}")
    gameList = SiriAddViews.new
    gameList.make_root(last_ref_id)
    for x in (0..4) do
      gameArray = []
      gameArray << SiriAnswerLine.new("#{games.played_games[x].title} image","#{games.played_games[x].art['BoxArt']}")
      gameArray << SiriAnswerLine.new("Gamerscore: #{games.played_games[x].earned_gamerscore}/#{games.played_games[x].possible_gamerscore}")
      gameArray << SiriAnswerLine.new("Achievements: #{games.played_games[x].earned_achievements}/#{games.played_games[x].possible_achievements}")
      gameArray << SiriAnswerLine.new("#{games.played_games[x].percentage_completed}")
      gameX = SiriAnswer.new("#{games.played_games[x].title}", gameArray)
      gameList.views << SiriAnswerSnippet.new([gameX])
    end
    send_object gameList
  end
  
  listen_for /Is (.*) online/i do |usertag|
    gamertag = makeName(usertag)
    
  end
  
  listen_for /My recent games/i do
    games = GamertagGames.new("#{@myTag}")
    gameList = SiriAddViews.new
    gameList.make_root(last_ref_id)
    for x in (0..4) do
      gameArray = []
      gameArray << SiriAnswerLine.new("#{games.played_games[x].title} image","#{games.played_games[x].art['BoxArt']}")
      gameArray << SiriAnswerLine.new("Gamerscore: #{games.played_games[x].earned_gamerscore}/#{games.played_games[x].possible_gamerscore}")
      gameArray << SiriAnswerLine.new("Achievements: #{games.played_games[x].earned_achievements}/#{games.played_games[x].possible_achievements}")
      gameArray << SiriAnswerLine.new("#{games.played_games[x].percentage_completed}")
      gameX = SiriAnswer.new("#{games.played_games[x].title}", gameArray)
      gameList.views << SiriAnswerSnippet.new([gameX])
    end
    send_object gameList
  end
  
  listen_for /Compare my gamertag with (.*)/i, within_state: :has_gamertag do |usertag| #Only gets processed if you're within the :has_gamertag state!
    gamertag = makeName(usertag)
    
  end
end
