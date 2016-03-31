Feature: works from the command line

Scenario: Asking for help
    Given I am a normal user
    When I successfully run `exe/with_ethics -h`
    Then the output should contain "-h, --help                       Display this screen"
    
Scenario: Specifying promises file
    Given a file named "features/promises.yml" with:
    """
        globals:
          language: ruby
    """
    Then I successfully run `exe/with_ethics --file features/promises.yml -s`

Scenario: Specifying root
    Given a directory named "features"
    And a file named "promises.yml" with:
    """
        globals:
          language: ruby
    """
    Then I successfully run `exe/with_ethics --root features --file promises.yml -s`
    
Scenario: Finding promises at root
    Given a directory named "features"
    And a file named "features/promises.yml" with:
    """
        globals:
          language: ruby
    """
    Then I successfully run `exe/with_ethics --root features -s`
