require "spec_helper"

describe Lita::Handlers::Resistance, lita_handler: true do
  before(:each) do
    a = Lita::User.create(1, {name: 'a', mention_name: 'a'})
    b = Lita::User.create(2, {name: 'b', mention_name: 'b'})
    c = Lita::User.create(3, {name: 'c', mention_name: 'c'})
    d = Lita::User.create(4, {name: 'd', mention_name: 'd'})
    e = Lita::User.create(5, {name: 'e', mention_name: 'e'})
  end

  describe "help" do
    it "should provide help" do
      send_command('resistance help')
      expect(replies.last).to include('Commands:') # First line
    end
  end

  describe "with no special characters" do
    it 'should not start a game with more than 10 players' do
      f = Lita::User.create(6, {name: 'f', mention_name: 'f'})
      g = Lita::User.create(7, {name: 'g', mention_name: 'g'})
      h = Lita::User.create(8, {name: 'h', mention_name: 'h'})
      i = Lita::User.create(9, {name: 'i', mention_name: 'i'})
      j = Lita::User.create(10, {name: 'j', mention_name: 'j'})
      k = Lita::User.create(11, {name: 'k', mention_name: 'k'})

      send_command('resistance N a b c d e f g h i j k')
      expect(replies.last).to eq('You cannot play a game of Resistance with more than 10 players.')
    end

    it 'should not start a game with unknown users' do
      send_command('resistance N a b c d @e f')
      expect(replies.last).to eq('The following are not users: @f')
    end

    it 'should start a game with 5 players' do
      send_command('resistance N a b c d @e')
      expect(replies.last).to include('Roles have been assigned to the selected people!')
    end

    it 'should start a game with 7 players' do
      f = Lita::User.create(6, {name: 'f', mention_name: 'f'})
      g = Lita::User.create(7, {name: 'g', mention_name: 'g'})
      send_command('resistance N a b c d e f g')
      expect(replies.last).to include('Roles have been assigned to the selected people!')
    end

    it 'should not start a game with less than 5 players' do
      send_command('resistance N a b c d')
      expect(replies.last).to eq('You need at least 5 players for Resistance.')
    end

    it 'should not start a game with 2 Ns' do
      send_command('resistance NN a b c d @e')
      expect(replies.last).to eq('You cannot have more than one of the same character.')
    end
  end

  describe "with special characters" do
    it 'should not start a game with multiple of the same character' do
      send_command('resistance CC a b c d @e')
      expect(replies.last).to eq('You cannot have more than one of the same character.')
    end

    it 'should not start a game with a special character and N' do
      send_command('resistance NC a b c d @e')
      expect(replies.last).to eq('You cannot include special characters with N.')
    end

    it 'should not start a game with more special spies than spies' do
      send_command('resistance ADF a b c d @e')
      expect(replies.last).to eq('You cannot have more special characters on spies than the number of spies.')
    end

    it 'should start a game with 5 players' do
      send_command('resistance BCDF a b c d @e')
      expect(replies.last).to include('Roles have been assigned to the selected people!')
    end

    it 'should start a game with 7 players' do
      f = Lita::User.create(6, {name: 'f', mention_name: 'f'})
      g = Lita::User.create(7, {name: 'g', mention_name: 'g'})
      send_command('resistance ABCFS a b c d e f g')
      expect(replies.last).to include('Roles have been assigned to the selected people!')
    end
  end
end
