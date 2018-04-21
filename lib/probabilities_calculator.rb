# frozen_string_literal: true

# Calculates the probabilities of every combination of pairs.
class ProbabilitiesCalculator
  def initialize(
    base_group, evaluated_group, possible_evaluated_group_permutations
  )
    @base_group = base_group
    @evaluated_group = evaluated_group
    @possible_evaluated_group_permutations =
      possible_evaluated_group_permutations
  end

  def probabilities
    Hash[@base_group.map do |base_group_candidate|
      [
        base_group_candidate,
        Hash[@evaluated_group.map do |evaluated_group_candidate|
          [
            evaluated_group_candidate,
            hash_for_pair(base_group_candidate, evaluated_group_candidate)
          ]
        end]
      ]
    end]
  end

  private

  def hash_for_pair(base_group_candidate, evaluated_group_candidate)
    possible_permutations_for_pair_count =
      possible_permutations_for_pair_count(
        base_group_candidate, evaluated_group_candidate
      )
    probability = (
      possible_permutations_for_pair_count.to_f / possible_permutations_count
    )

    {
      possible_permutations: possible_permutations_for_pair_count,
      probability: probability
    }
  end

  def possible_permutations_for_pair_count(
    base_group_candidate, evaluated_group_candidate
  )
    index = @base_group.index(base_group_candidate)

    @possible_evaluated_group_permutations.find_all do |permutation|
      permutation[index] == evaluated_group_candidate
    end.count
  end

  def possible_permutations_count
    @possible_permutations_count ||=
      @possible_evaluated_group_permutations.count
  end
end
