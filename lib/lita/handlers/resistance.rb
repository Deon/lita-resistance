module Lita
  module Handlers
    class Resistance < Handler

      route(/resistance help/, :help, command: true, help: {'resistance help' => 'Provides detailed help with Resistance commands.'})

      route(/resistance [NCBSAFD]+ .+/, :play, command: true, help: {'resistance N|[CBSAFD] [users]' => 'Starts a game of resistance with the people you mention.'})

      def help (response)
        response.reply(render_template("help"))
      end

      # Remove any "@" from usernames
      def normalize_input! (all_users)
        all_users.map! do |username|
          if username[0] == '@'
            username[1, username.length-1]
          else
            username
          end
        end
      end

      def verify_characters (characters)
        if characters != characters.uniq
          raise 'You cannot have more than one of the same character.'
        end

        if characters.include?('N') && characters.length > 1
          raise 'You cannot include special characters with N.'
        end

        # Num of Special Characters on spies doesn't exceed num of spies
        if !characters.include?('N') && (characters - ['C', 'B']).length > @num_spies
          raise 'You cannot have more special characters on spies than the number of spies.'
        end
      end

      def validate_input (response)
        input_args = response.args.uniq
        @characters = input_args[0].split(//)
        all_users = input_args[1, input_args.length - 1] # User mention_names

        if all_users.length < 5
          raise 'You need at least 5 players for Resistance.'
        elsif all_users.length > 10
          raise 'You cannot play a game of Resistance with more than 10 players.'
        end

        @num_spies = (all_users.length + 2) / 3

        verify_characters(@characters)

        normalize_input!(all_users)

        # Ensure all people are users.
        unknown_users = []
        all_users.each do |username|
          user = Lita::User.find_by_mention_name(username)
          unknown_users.push(username) unless user
        end

        if unknown_users.any?
          raise "The following are not users: @#{unknown_users.join(' @')}"
        end

        all_users
      end

      def assign_spies (spies)
        spy_specials = {}
        if @characters.include?('D')
          spy_specials[:deep_cover] = spies.sample
        end

        if @characters.include?('F')
          spy_specials[:false_commander] = (spies - spy_specials.values).sample
        end

        if @characters.include?('B')
          spy_specials[:blind_spy] = (spies - spy_specials.values).sample
        end

        if @characters.include?('A')
          spy_specials[:assassin] = (spies - spy_specials.values).sample
        end

        spies.each do |member|
          user = Lita::User.find_by_mention_name(member)
          other_spies = spies.dup - [spy_specials[:blind_spy], member] # Don't mention Blind Spy or self
          robot.send_message(Source.new(user: user),
                             render_template('spy', { spy_specials: spy_specials,
                                                      other_spies: other_spies,
                                                      member: member,
                                                      starter: @starter,
                                                      game_id: @game_id }))
        end
        spy_specials
      end

      def assign_resistance (resistance, spies, spy_specials)
        if @characters.include?('C')
          commander = resistance.sample
          commander_visible = spies - [spy_specials[:deep_cover]]
        end

        if @characters.include?('B')
          bodyguard = (resistance - [commander]).sample
          bodyguard_visible = [commander, spy_specials[:false_commander]].shuffle.compact
        end

        resistance.each do |member|
          user = Lita::User.find_by_mention_name(member)
          robot.send_message(Source.new(user: user),
                             render_template("resistance", { commander: commander,
                                                             bodyguard: bodyguard,
                                                             bodyguard_visible: bodyguard_visible,
                                                             commander_visible: commander_visible,
                                                             member: member,
                                                             starter: @starter,
                                                             game_id: @game_id,
                                                             spy_specials: spy_specials }))

        end
      end

      def play(response)
        begin
          all_users = validate_input(response)
        rescue StandardError => error
          response.reply(error.to_s) and return
        end

        @game_id = rand(999999)
        @starter = response.user.mention_name # Person who started the game
        # Form teams
        spies = all_users.sample(@num_spies)
        resistance = all_users - spies

        spy_specials = assign_spies(spies)
        assign_resistance(resistance, spies, spy_specials)

        leader = all_users.sample # Randomly pick a leader for the first round
        response.reply("Roles have been assigned to the selected people! This is game ID ##{@game_id}. @#{leader} will be leading off the first round.")
      end

      Lita.register_handler(self)
    end
  end
end
