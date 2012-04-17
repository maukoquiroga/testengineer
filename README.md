# TestEngineer


TestEngineer is a simple gem which adds some code around
[foreman](https://github.com/ddollar/foreman) for integration testing.

Currently it allows you to bring up an entire stack, based on what is defined
in the Foreman `Procfile`, for the duration of a test case.

TestEngineer also allows you to arbitrarily shut off processes by name during
the runtime of a test case.



## With Cucumber

There is an `Around` hook that you can include with
`require 'testengineer/cucumber'`. This will wrap any Scenario tagged with the
`@testengineer` tag.

Imagine a `Procfile` such as:

    web: ruby -r thin app.rb
    db: ./script/run-mongodb
    cache: memcached

A sample Cucumber feature might look like:


    @testengineer
    Feature: Log in to My Site
      In order to facilitate meaningful relationships between users
      As a web visitor
      I should be able to log into my account on My Site

    Scenario: Log in
      Given an account named "octocat"
      When I log in to My Site
      Then I should be delighted with my fabulous profile

    Scenario: Log in when the site is degraded
      Given an account named "octocat"
      And the database is offline
      When I log in to My Site
      Then I should see a nice friendly fail whale.


For each scenario, TestEngineer will bring the entire stack (web, db, cache) up
and down. In the second scenario, I would have defined the step for `And the
database is offline` as:

    Given /^the database is offline$/ do
      TestEngineer.stop_process('db')
    end


