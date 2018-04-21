# frozen_string_literal: true

# Representation of a ceremony.
#
# `evaluated_group_candidates` is expected to be an ordered list of names
# matching index-for-index with a base group list.
class Ceremony
  attr_accessor :evaluated_group_candidates, :match_count

  def initialize(evaluated_group_candidates, match_count)
    @evaluated_group_candidates = evaluated_group_candidates
    @match_count = match_count
  end

  def number_of_common_pairs_same_as_match_count?(other_candidates_list)
    number_of_common_pairs(other_candidates_list) == @match_count
  end

  def number_of_common_pairs(other_candidates_list)
    (0...@evaluated_group_candidates.count).reduce(0) do |n, i|
      if @evaluated_group_candidates[i] == other_candidates_list[i]
        n + 1
      else
        n
      end
    end
  end
end
