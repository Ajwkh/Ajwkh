Feature: Demo

  Background: 
    #in Karate we use * instead of using gherkin keywords (Given, When, Then)
    #in Karate we use url keyword to pass the endpoint url or base url
    * url 'https://jsonplaceholder.typicode.com'

 
  Scenario: getAll users
    #in karate we use keyword path to pass the service name
    #in karate we use method keyword to specify what is method type of this request
    #in karate we status keyword to validate the response status code
    #in karate we use print to print the value in console
    #in karate we use response keyword to store json response
    Given path 'users'
    When method get
    Then status 200
    * print response
    * def idvalue = response[0].id
    * print idvalue

  Scenario: create a user
    #in karate we send json body in three double """
    #in karate we use request keyword following with three double """ to send a json body.
    #in karate match keyword is == to assert.assertEquals
    #in karate if we need to validate json response values we need to write
    #response.jsonkey for example for name key we need to write response.name
    Given path 'users'
    When request
      """
          {
             "name": "James Bond",
             "username": "bond007",
             "email": "james.bond@gmail.com",
             "address": {
               "street": "007 No time to die",
               "suite": "Apt. 007",
               "city": "London",
               "zipcode": "54321-6789"
             }
           }
      """
    And method post
    Then status 201
    * print response
    * match response.name == 'James Bond'
    * match response.address.city == 'London'
    * match response.username != 'bond008'
    * match response.email contains '.com'
    * def name = response.name
    * match name == '#string'
    * def zipcode = response.address.zipcode
    * match zipcode =='#number'

@test
  Scenario Outline: dataDriven scenario
    Given path 'users'
    When request
      """
          {
             "name": "<name>",
             "username": "<username>",
             "email": "<email>",
             "address": {
               "street": "<street>",
               "suite": "<suite>",
               "city": "<city>",
               "zipcode": "<zipcode>"
             }
           }
      """
    And method post
    Then status 201
    * print response
    * match response.name == '<name>'
    * match response.address.city == '<city>'
    * match response.username != 'bond008'
    * match response.email contains '.com'
    * def name = response.name
    * match name == '#string'
    * def zipcode = response.address.zipcode
    * match zipcode !='#number'

    Examples: 
      | name  | username | email           | street       | suite   | city       | zipcode    |
      | alex  | alex001  | alex@gmail.com  | 123 no where | apt 111 | London     | 22185-5525 |
      | jack  | jack001  | jack@gmail.com  | 123 no where | apt 111 | New york   | 22185-5525 |
      | ahmad | ahmad001 | ahmad@gmail.com | 123 no where | apt 111 | Washington | 22185-5525 |
      | sasha | sasha001 | sasha@gmail.com | 123 no where | apt 111 | Paris      | 22185-5525 |
