#!/usr/bin/env ruby
# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective, Metrics/LineLength

require './lib/possible_permutations_resolver'

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
  { men: %w[Pontus Martin Diego Christoffer Patrick/Stefan Jonatan Shad Kevin Robin Robert], matches: 2 },
  { men: %w[Kevin Patrick/Stefan Martin Robert Robin Pontus Shad Christoffer Diego Jonatan], matches: 1 },
  { men: %w[Kevin Robert Robin Christoffer Shad Jonatan Martin Diego Patrick/Stefan Pontus], matches: 4 },
  { men: %w[Kevin Martin Patrick/Stefan Christoffer Shad Jonatan Diego Pontus Robert Robin], matches: 4 },
  { men: %w[Kevin Martin Christoffer Pontus Shad Jonatan Robin Diego Patrick/Stefan Robert], matches: 5 },
  { men: %w[Kevin Martin Robert Robin Shad Jonatan Diego Pontus Patrick/Stefan Christoffer], matches: 6 },
  { men: %w[Diego Martin Christoffer Robin Shad Jonatan Kevin Pontus Patrick/Stefan Robert], matches: 4 },
  { men: %w[Kevin Martin Diego Pontus Shad Jonatan Robert Robin Patrick/Stefan Christoffer], matches: 4 }
]

possible_men_permutations = PossiblePermutationsResolver.new(
  women, men, matchboxes, ceremonies
).possible_permutations

number_of_permutations = possible_men_permutations.count

puts "There are #{number_of_permutations} possible combinations remaining (initially 3628800)"
puts

if number_of_permutations < 5
  puts women.join(';')
  possible_men_permutations.each do |men_permutation|
    puts men_permutation.join(';')
  end
  puts
end

print ';'
puts men.join(';')

(0...women.count).each do |i|
  woman = women[i]
  probabilities = men.map do |man|
    possible_matches = possible_men_permutations.find_all do |men_permutation|
      men_permutation[i] == man
    end.count
    probability = (possible_matches.to_f / number_of_permutations * 100).round(3).to_s.tr('.', ',')
    "#{probability}%"
  end

  print "#{woman};"
  puts probabilities.join(';')
end
