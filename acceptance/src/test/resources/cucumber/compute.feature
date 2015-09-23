Feature: Compute
  As a user
  I want to use a computer
  So that I don't need to calculate myself

  Scenario: Add two numbers
    Given I have a computer
    When I sum 3 and 2
    Then the result from computer should be 5