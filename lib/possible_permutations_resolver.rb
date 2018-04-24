# frozen_string_literal: true

require './lib/matchbox'
require './lib/ceremony'

# Resolves all possible permutations of candidates of the `evaluated_group`
# list based on information from lists of previous `matchboxes` and
# `ceremonies`. Permutations corresponds index-for-index with the `base_group`
# list of candidates.
#
# Starting with a complete list of permutations of `evaluated_group`,
# permutations are removed when:
#
# 1. They contain pairs that are confirmed to be no matches according to
#    previous matchboxes.
# 2. The number of common pairs with any previous ceremony is different from
#    each ceremony's number of confirmed couples.
class PossiblePermutationsResolver
  def initialize(base_group, evaluated_group, matchboxes, ceremonies)
    @base_group = base_group
    @evaluated_group = evaluated_group
    @matchboxes = matchboxes
    @ceremonies = ceremonies
  end

  def possible_permutations
    @evaluated_group.permutation.find_all do |permutation|
      all_pairs_possible_according_to_matchboxes?(permutation) &&
        number_of_common_pairings_same_as_matches_all_ceremonies?(permutation)
    end
  end

  private

  def all_pairs_possible_according_to_matchboxes?(evaluated_group_permutation)
    evaluated_group_permutation.each_with_index.all? do |candidate, i|
      pair_possible_according_to_matchboxes?(@base_group[i], candidate)
    end
  end

  def number_of_common_pairings_same_as_matches_all_ceremonies?(permutation)
    @ceremonies.all? do |ceremony|
      ceremony.number_of_common_pairs_same_as_match_count?(permutation)
    end
  end

  def pair_possible_according_to_matchboxes?(
    base_group_candidate, evaluated_group_candidate
  )
    !pair_unmatched_in_matchbox?(
      base_group_candidate, evaluated_group_candidate
    ) && !pair_matched_with_someone_else_in_matchbox?(
      base_group_candidate, evaluated_group_candidate
    )
  end

  def pair_unmatched_in_matchbox?(
    base_group_candidate, evaluated_group_candidate
  )
    matchboxes_unmatched.any? do |m|
      m.base_group_candidate == base_group_candidate &&
        m.evaluated_group_candidate == evaluated_group_candidate
    end
  end

  def pair_matched_with_someone_else_in_matchbox?(
    base_group_candidate, evaluated_group_candidate
  )
    matchboxes_matched.any? do |m|
      m.base_group_candidate == base_group_candidate &&
        m.evaluated_group_candidate != evaluated_group_candidate
    end || matchboxes_matched.any? do |m|
      m.evaluated_group_candidate == evaluated_group_candidate &&
        m.base_group_candidate != base_group_candidate
    end
  end

  def matchboxes_matched
    @matchboxes_matched ||= @matchboxes.find_all(&:match?)
  end

  def matchboxes_unmatched
    @matchboxes_unmatched ||= @matchboxes.find_all(&:no_match?)
  end
end
