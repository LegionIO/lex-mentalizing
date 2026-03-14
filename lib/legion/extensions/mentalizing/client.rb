# frozen_string_literal: true

require 'legion/extensions/mentalizing/helpers/constants'
require 'legion/extensions/mentalizing/helpers/belief_attribution'
require 'legion/extensions/mentalizing/helpers/mental_model'
require 'legion/extensions/mentalizing/runners/mentalizing'

module Legion
  module Extensions
    module Mentalizing
      class Client
        include Runners::Mentalizing

        def initialize(**)
          @mental_model = Helpers::MentalModel.new
        end

        private

        attr_reader :mental_model
      end
    end
  end
end
