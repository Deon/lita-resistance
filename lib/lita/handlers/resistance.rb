module Lita
  module Handlers
    class Resistance < Handler

      route(/resistance .+/, :play, command: true, help: {'resistance [users]' => 'Starts a game of resistance with the people you mention.'})
      def play(response)
        all_users = response.args.uniq

        if all_users.length < 5
          response.reply('You need at least 5 players for Resistance.')
          return
        elsif all_users.length > 10
          response.reply('You cannot play a game of Resistance with more than 10 players.')
          return
        end

        # Remove any "@" from usernames
        all_users.map! {|username|
          if username[0] == '@'
            username = username[1, username.length-1]
          else
            username = username
          end
        }

        # Ensure all people are users.
        unknown_users = []
        all_users.each do |username|
          user = Lita::User.find_by_mention_name(username)
          unknown_users.push(username) unless user
        end

        if unknown_users.any?
          response.reply('The following are not users. Please check your spelling and try again.')
          unknown_users.each do |user|
            response.reply(user)
          end and return
        end

        gameId = rand(999999)

        # Form teams
        spies = all_users.sample((all_users.length+2)/3)
        resistance = all_users - spies

        spies.each do |member|
          user = Lita::User.find_by_mention_name(member)
          robot.send_message(Source.new(user: user),"@#{response.user.mention_name} has started game ID##{gameId} of Resistance. You are a member of the spies.")
        end

        resistance.each do |member|
          user = Lita::User.find_by_mention_name(member)
          robot.send_message(Source.new(user: user), "@#{response.user.mention_name} has started game ID##{gameId} of Resistance. You are a member of the resistance.")
        end

        response.reply("Roles have been assigned to the selected people! This is game ID##{gameId}")
      end
      
      Lita.register_handler(self)
    end
  end
end
