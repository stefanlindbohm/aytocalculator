#!/usr/bin/env ruby
# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective, Metrics/LineLength

require './lib/possible_permutations_resolver'
require './lib/probabilities_calculator'

women = %w[Angelica Renara Malin Anna Maria My Sanna Valle Mariele Emma]
men = %w[Pontus Martin Diego Christoffer Patrick/Stefan Jonatan Shad Kevin Robin Robert]

matchboxes = [
  Matchbox.new('Mariele', 'Pontus', false),
  Matchbox.new('Sanna', 'Robert', false),
  Matchbox.new('Malin', 'Diego', false),
  Matchbox.new('Emma', 'Pontus', false),
  Matchbox.new('Maria', 'Shad', true),
  Matchbox.new('Anna', 'Christoffer', false),
  Matchbox.new('Malin', 'Kevin', false),
  Matchbox.new('My', 'Jonatan', true)
]

# Indicies for men corresponds to `women`
ceremonies = [
  Ceremony.new(%w[Pontus Martin Diego Christoffer Patrick/Stefan Jonatan Shad Kevin Robin Robert], 2),
  Ceremony.new(%w[Kevin Patrick/Stefan Martin Robert Robin Pontus Shad Christoffer Diego Jonatan], 1),
  Ceremony.new(%w[Kevin Robert Robin Christoffer Shad Jonatan Martin Diego Patrick/Stefan Pontus], 4),
  Ceremony.new(%w[Kevin Martin Patrick/Stefan Christoffer Shad Jonatan Diego Pontus Robert Robin], 4),
  Ceremony.new(%w[Kevin Martin Christoffer Pontus Shad Jonatan Robin Diego Patrick/Stefan Robert], 5),
  Ceremony.new(%w[Kevin Martin Robert Robin Shad Jonatan Diego Pontus Patrick/Stefan Christoffer], 6),
  Ceremony.new(%w[Diego Martin Christoffer Robin Shad Jonatan Kevin Pontus Patrick/Stefan Robert], 4),
  Ceremony.new(%w[Kevin Martin Diego Pontus Shad Jonatan Robert Robin Patrick/Stefan Christoffer], 4)
]

possible_men_permutations = PossiblePermutationsResolver.new(
  women, men, matchboxes, ceremonies
).possible_permutations

number_of_permutations = possible_men_permutations.count

probabilities = ProbabilitiesCalculator.new(
  women, men, possible_men_permutations
).probabilities

puts "There #{number_of_permutations == 1 ? 'is' : 'are'} #{number_of_permutations} possible combination#{'s' unless number_of_permutations == 1} remaining (initially 3628800)"
puts

if number_of_permutations <= 5
  possible_men_permutations.each do |men_permutation|
    men_permutation.each_with_index do |man, i|
      puts "#{women[i]} & #{man}"
    end
    puts
  end
end

print ';'
puts men.join(';')

probabilities.each do |woman, men_probabilities|
  printable_probabilities = men_probabilities.map do |_, m|
    "#{(m[:probability] * 100).round(3).to_s.tr('.', ',')}%"
  end

  print "#{woman};"
  puts printable_probabilities.join(';')
end
