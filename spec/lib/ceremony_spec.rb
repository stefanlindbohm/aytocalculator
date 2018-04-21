# frozen_string_literal: true

require './lib/ceremony'

RSpec.describe Ceremony do
  let(:other_candidates_list) { %w[Uno Dos Tres] }

  describe '#number_of_common_pairs_same_as_match_count?' do
    it 'returns true when number of common pairs is same' do
      ceremony = Ceremony.new(%w[Uno Tres Dos], 1)

      expect(
        ceremony.number_of_common_pairs_same_as_match_count?(
          other_candidates_list
        )
      ).to be true
    end

    it 'returns false when number of common pairs is different' do
      ceremony = Ceremony.new(%w[Tres Uno Dos], 1)

      expect(
        ceremony.number_of_common_pairs_same_as_match_count?(
          other_candidates_list
        )
      ).to be false
    end
  end

  describe '#number_of_common_pairs' do
    it 'calculates the number of common pairs for a given list' do
      ceremony = Ceremony.new(%w[Uno Tres Dos], 1)

      expect(ceremony.number_of_common_pairs(other_candidates_list))
        .to eq(1)
    end
  end
end
