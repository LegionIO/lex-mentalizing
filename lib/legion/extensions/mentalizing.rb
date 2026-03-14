# frozen_string_literal: true

require 'securerandom'
require 'legion/extensions/mentalizing/version'
require 'legion/extensions/mentalizing/helpers/constants'
require 'legion/extensions/mentalizing/helpers/belief_attribution'
require 'legion/extensions/mentalizing/helpers/mental_model'
require 'legion/extensions/mentalizing/runners/mentalizing'
require 'legion/extensions/mentalizing/client'

module Legion
  module Extensions
    module Mentalizing
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
