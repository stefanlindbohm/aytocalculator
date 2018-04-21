# frozen_string_literal: true

require './lib/matchbox'

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
    (0...@base_group.count).all? do |i|
      pair_possible_according_to_matchboxes?(
        @base_group[i],
        evaluated_group_permutation[i]
      )
    end
  end

  def number_of_common_pairings_same_as_matches_all_ceremonies?(permutation)
    @ceremonies.all? do |ceremony|
      common_pairings(permutation, ceremony[:men]) ==
        ceremony[:matches]
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

  def common_pairings(list1, list2)
    (0...list1.count).reduce(0) do |n, i|
      if list1[i] == list2[i]
        n + 1
      else
        n
      end
    end
  end
end
