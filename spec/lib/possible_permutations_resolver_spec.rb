# frozen_string_literal: true

require './lib/possible_permutations_resolver'

RSpec.describe PossiblePermutationsResolver do
  let(:base_group) { %w[First Second Third] }
  let(:evaluated_group) { %w[Uno Dos Tres] }

  describe '#possible_permutations' do
    it 'returns all permutations when no matchboxes or ceremonies are given' do
      resolver = PossiblePermutationsResolver.new(
        base_group, evaluated_group, [], []
      )

      expect(resolver.possible_permutations).to eq(
        [
          %w[Uno Dos Tres],
          %w[Uno Tres Dos],
          %w[Dos Uno Tres],
          %w[Dos Tres Uno],
          %w[Tres Uno Dos],
          %w[Tres Dos Uno]
        ]
      )
    end

    it 'returns only permutations valid according to a matched matchbox' do
      resolver = PossiblePermutationsResolver.new(
        base_group,
        evaluated_group,
        [Matchbox.new('First', 'Uno', true)],
        []
      )

      expect(resolver.possible_permutations).to eq(
        [
          %w[Uno Dos Tres],
          %w[Uno Tres Dos]
        ]
      )
    end

    it 'returns only permutations valid according to an unmatched matchbox' do
      resolver = PossiblePermutationsResolver.new(
        base_group,
        evaluated_group,
        [Matchbox.new('First', 'Uno', false)],
        []
      )

      expect(resolver.possible_permutations).to eq(
        [
          %w[Dos Uno Tres],
          %w[Dos Tres Uno],
          %w[Tres Uno Dos],
          %w[Tres Dos Uno]
        ]
      )
    end

    it 'returns only permutations valid according to a ceremony' do
      resolver = PossiblePermutationsResolver.new(
        base_group,
        evaluated_group,
        [],
        [Ceremony.new(%w[Uno Dos Tres], 1)]
      )

      expect(resolver.possible_permutations).to eq(
        [
          %w[Uno Tres Dos],
          %w[Dos Uno Tres],
          %w[Tres Dos Uno]
        ]
      )
    end
  end
end
