require 'cora'
require 'siri_objects'
require 'gamertag'

class SiriProxy::Plugin::Gamertag < SiriProxy::Plugin
  
  def initialize(config)
    if config['Gamertag']
      @myTag = config['Gamertag']
      set_state :has_gamertag
    else
      puts "[SiriProxy::Plugin::Gamertag] NO GAMERTAG SPECIFIED!"
      set_state nil #clear out the state, in case they remove their gamertag from the config.yml
    end
  end
  
  def makeName(tag)
    
  end
  
  listen_for /Gamertag (.*)/i do |usertag|
    gamertag = makeName(usertag)
  end
  
  listen_for /Recent games for (.*)/i do |usertag|
#    gamertag = makeName(usertag)
    played_games = Gamertag::PlayedGames.new("Ponyboy47")
    gameList = SiriAddViews.new
    gameList.make_root(last_ref_id)
    x = 0
    played_games.each do |game|
      if x < 5
        gameArray = []
        gameArray << SiriAnswerLine.new("#{game.title} image","#{game.image}")
        say "#{game.title}"
        gameArray << SiriAnswerLine.new("Gamerscore: #{game.earned_gamerscore}/#{game.available_gamerscore}. #{game.relative_gamerscore}")
        say "Gamerscore: #{game.earned_gamerscore}/#{game.available_gamerscore}. #{game.relative_gamerscore}"
        gameArray << SiriAnswerLine.new("Achievments: #{game.earned_achievements}/#{game.available_achievements}")
        say "Achievments: #{game.earned_achievements}/#{game.available_achievements}"
        gameArray << SiriAnswerLine.new("#{game.percentage_complete}")
        say "#{game.percentage_complete}"
        gameX = SiriAnswer.new("#{game.title}", gameArray)
        gameList.views << SiriAnswerSnippet.new([gameX])
        x += 1
      else
        break
      end
    end
    send_object gameList
  end
  
  listen_for /Is (.*) online/i do |usertag|
    gamertag = makeName(usertag)
    
  end
  
  listen_for /My recent games/i do 
    played_games = Gamertag::PlayedGames.new("#{@myTag}")
    gameList = SiriAddViews.new
    gameList.make_root(last_ref_id)
    x = 0
    played_games.each do |game|
      if x < 5
        gameArray = []
        gameArray << SiriAnswerLine.new("#{game.title} image","#{game.image}")
        say "#{game.title}"
        gameArray << SiriAnswerLine.new("Gamerscore: #{game.earned_gamerscore}/#{game.available_gamerscore}. #{game.relative_gamerscore}")
        say "Gamerscore: #{game.earned_gamerscore}/#{game.available_gamerscore}. #{game.relative_gamerscore}"
        gameArray << SiriAnswerLine.new("Achievments: #{game.earned_achievements}/#{game.available_achievements}")
        say "Achievments: #{game.earned_achievements}/#{game.available_achievements}"
        gameArray << SiriAnswerLine.new("#{game.percentage_complete}")
        say "#{game.percentage_complete}"
        gameX = SiriAnswer.new("#{game.title}", gameArray)
        gameList.views << SiriAnswerSnippet.new([gameX])
        x += 1
      else
        break
      end
    end
    send_object gameList
  end
  
  listen_for /Compare my gamertag with (.*)/i, within_state: :has_gamertag do |usertag| #Only gets processed if you're within the :has_gamertag state!
    gamertag = makeName(usertag)
    
  end
end