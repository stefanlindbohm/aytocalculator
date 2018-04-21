# frozen_string_literal: true

require './lib/probabilities_calculator'

RSpec.describe ProbabilitiesCalculator do
  let(:base_group) { %w[First Second Third] }
  let(:evaluated_group) { %w[Uno Dos Tres] }
  let(:possible_evaluated_group_permutations) do
    [
      %w[Uno Dos Tres],
      %w[Dos Uno Tres]
    ]
  end

  describe '#probabilities' do
    it 'returns a hash of base group candidates each containing hashes for' \
      'evaluated group candidates' do
      calculator = ProbabilitiesCalculator.new(
        base_group, evaluated_group, possible_evaluated_group_permutations
      )

      probabilities = calculator.probabilities

      expect(probabilities.keys).to eq(%w[First Second Third])
      expect(probabilities['First'].keys).to eq(%w[Uno Dos Tres])
      expect(probabilities['Second'].keys).to eq(%w[Uno Dos Tres])
      expect(probabilities['Third'].keys).to eq(%w[Uno Dos Tres])
    end

    it 'returns the count of possible permutations involving each pair' do
      calculator = ProbabilitiesCalculator.new(
        base_group, evaluated_group, possible_evaluated_group_permutations
      )

      probabilities = calculator.probabilities

      expect(probabilities['First']['Uno'][:possible_permutations]).to eq(1)
      expect(probabilities['First']['Dos'][:possible_permutations]).to eq(1)
      expect(probabilities['First']['Tres'][:possible_permutations]).to eq(0)
      expect(probabilities['Second']['Uno'][:possible_permutations]).to eq(1)
      expect(probabilities['Second']['Dos'][:possible_permutations]).to eq(1)
      expect(probabilities['Second']['Tres'][:possible_permutations]).to eq(0)
      expect(probabilities['Third']['Uno'][:possible_permutations]).to eq(0)
      expect(probabilities['Third']['Dos'][:possible_permutations]).to eq(0)
      expect(probabilities['Third']['Tres'][:possible_permutations]).to eq(2)
    end

    it 'returns the probabilities involving each pair' do
      calculator = ProbabilitiesCalculator.new(
        base_group, evaluated_group, possible_evaluated_group_permutations
      )

      probabilities = calculator.probabilities

      expect(probabilities['First']['Uno'][:probability]).to eq(0.5)
      expect(probabilities['First']['Dos'][:probability]).to eq(0.5)
      expect(probabilities['First']['Tres'][:probability]).to eq(0)
      expect(probabilities['Second']['Uno'][:probability]).to eq(0.5)
      expect(probabilities['Second']['Dos'][:probability]).to eq(0.5)
      expect(probabilities['Second']['Tres'][:probability]).to eq(0)
      expect(probabilities['Third']['Uno'][:probability]).to eq(0)
      expect(probabilities['Third']['Dos'][:probability]).to eq(0)
      expect(probabilities['Third']['Tres'][:probability]).to eq(1)
    end
  end
end
