# frozen_string_literal: true

require_relative 'lib/legion/extensions/mentalizing/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-mentalizing'
  spec.version       = Legion::Extensions::Mentalizing::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Mentalizing'
  spec.description   = 'Second-order Theory of Mind for brain-modeled agentic AI. ' \
                       'Recursive belief attribution, false-belief detection, and social alignment modeling.'
  spec.homepage      = 'https://github.com/LegionIO/lex-mentalizing'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/LegionIO/lex-mentalizing'
  spec.metadata['documentation_uri']     = 'https://github.com/LegionIO/lex-mentalizing'
  spec.metadata['changelog_uri']         = 'https://github.com/LegionIO/lex-mentalizing'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/LegionIO/lex-mentalizing/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-mentalizing.gemspec Gemfile]
  end
  spec.require_paths = ['lib']
end
