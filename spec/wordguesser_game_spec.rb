require 'spec_helper'
require 'wordguesser_game'

describe WordGuesserGame do
  def guess_several_letters(game, letters)
    letters.chars { |letter| game.guess(letter) }
  end

  describe 'new' do
    it "initializes game state" do
      game = described_class.new('glorp')
      expect(game.word).to eq('glorp')
      expect(game.guesses).to eq('')
      expect(game.wrong_guesses).to eq('')
    end
  end

  describe 'guessing' do
    context 'correctly' do
      before { @game = described_class.new('garply'); @valid = @game.guess('a') }

      it 'updates correct guesses' do
        expect(@game.guesses).to eq('a')
        expect(@game.wrong_guesses).to eq('')
      end

      it 'returns true' do
        expect(@valid).not_to be false
      end
    end

    context 'incorrectly' do
      before { @game = described_class.new('garply'); @valid = @game.guess('z') }

      it 'updates wrong guesses' do
        expect(@game.guesses).to eq('')
        expect(@game.wrong_guesses).to eq('z')
      end

      it 'returns true' do
        expect(@valid).not_to be false
      end
    end

    context 'same letter repeatedly' do
      before { @game = described_class.new('garply'); guess_several_letters(@game, 'aq') }

      it 'ignores repeated correct guess' do
        @game.guess('a')
        expect(@game.guesses).to eq('a')
      end

      it 'ignores repeated wrong guess' do
        @game.guess('q')
        expect(@game.wrong_guesses).to eq('q')
      end

      it 'returns false for repeated guesses' do
        expect(@game.guess('a')).to be false
        expect(@game.guess('q')).to be false
      end

      it 'is case insensitive' do
        expect(@game.guess('A')).to be false
        expect(@game.guess('Q')).to be false
        expect(@game.guesses).not_to include('A')
        expect(@game.wrong_guesses).not_to include('Q')
      end
    end

    context 'invalid input' do
      before { @game = described_class.new('foobar') }

      it { expect { @game.guess('') }.to raise_error(ArgumentError) }
      it { expect { @game.guess('%') }.to raise_error(ArgumentError) }
      it { expect { @game.guess(nil) }.to raise_error(ArgumentError) }
    end
  end

  describe 'displayed word with guesses' do
    before { @game = described_class.new('banana') }

    {
      'bn' => 'b-n-n-',
      'def' => '------',
      'ban' => 'banana'
    }.each do |guesses, displayed|
      it "is '#{displayed}' for guesses '#{guesses}'" do
        guess_several_letters(@game, guesses)
        expect(@game.word_with_guesses).to eq(displayed)
      end
    end
  end

  describe 'game status' do
    before { @game = described_class.new('dog') }

    it 'detects win' do
      guess_several_letters(@game, 'ogd')
      expect(@game.check_win_or_lose).to eq(:win)
    end

    it 'detects loss' do
      guess_several_letters(@game, 'tuvwxyz')
      expect(@game.check_win_or_lose).to eq(:lose)
    end

    it 'detects ongoing play' do
      guess_several_letters(@game, 'do')
      expect(@game.check_win_or_lose).to eq(:play)
    end
  end
end