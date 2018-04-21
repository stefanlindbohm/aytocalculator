# frozen_string_literal: true

# Representation of a matchbox.
class Matchbox
  attr_accessor :base_group_candidate, :evaluated_group_candidate, :match
  alias match? match

  def initialize(base_group_candidate, evaluated_group_candidate, match)
    @base_group_candidate = base_group_candidate
    @evaluated_group_candidate = evaluated_group_candidate
    @match = match
  end

  def no_match?
    !match?
  end
end
