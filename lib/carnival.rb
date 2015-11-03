require 'rubygems'
require 'simple_form'
require 'inherited_resources'
require 'carnival/engine'
require 'carnival/config'
require 'carnival/routes'
require 'carnival/version'
require 'haml-rails'
require 'coffee-rails'
require 'will_paginate'
require 'csv'
require 'bower-rails'
require 'rails-i18n'

module Carnival
  def self.configure
    yield(Carnival::Config)
  end
end
