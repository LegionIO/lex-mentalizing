# frozen_string_literal: true

require 'legion/extensions/actors/every'

module Legion
  module Extensions
    module Mentalizing
      module Actor
        class Decay < Legion::Extensions::Actors::Every
          def runner_class
            Legion::Extensions::Mentalizing::Runners::Mentalizing
          end

          def runner_function
            'update_mentalizing'
          end

          def time
            300
          end

          def run_now?
            false
          end

          def use_runner?
            false
          end

          def check_subtask?
            false
          end

          def generate_task?
            false
          end
        end
      end
    end
  end
end
