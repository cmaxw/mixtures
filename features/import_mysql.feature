Feature: MySQL import
  In order to create a dataset
  As a data manager
  I want to import MySQL tables

  Scenario: MySQL database with 1 record in 1 table
    Given I can connect to mysql
    And I have a database "foo"
    And "foo" has a table "bar"
    And "bar" has a "string" column "name"
    And "bar" has a "datetime" column "created_at"
    And "bar" has a record with id = "1"
    And the record has value "name" = "Chuck"
    And the record has value "created_at" = "2010-06-15 10:55:43"
    When I import "foo" to dataset "foo"
    Then I should have a record for dataset "foo" with table "bar" and id "1" 
    And the record has values "{'id': 1, 'name': 'Chuck', 'created_at': '2010-06-16 10:55:43'}"
  