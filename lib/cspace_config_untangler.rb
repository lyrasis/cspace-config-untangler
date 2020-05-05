# standard library
require 'csv'
require 'json'
require 'logger'
require 'pp'
require 'yaml'

# external gems
require 'bundler/setup'
require 'http'
require 'nokogiri'
require 'pry'
require 'thor'

module CspaceConfigUntangler
  ::CCU = CspaceConfigUntangler
  CCU.const_set('MAINPROFILE', 'core')
  CCU.const_set('PROFILES', %w[anthro bonsai botgarden fcart herbarium lhmc materials ohc publicart])
  CCU.const_set('CONFIGDIR', 'data/configs/5_2')
  File.delete('log.log') if File::exist?('log.log')
  CCU.const_set('LOG', Logger.new('log.log'))

  autoload :VERSION, 'cspace_config_untangler/version'
  autoload :CommandLine, 'cspace_config_untangler/command_line'

  autoload :Field, 'cspace_config_untangler/field'
  autoload :FieldDefinitionParser, 'cspace_config_untangler/field_definition_parser'
  autoload :Form, 'cspace_config_untangler/form'
  autoload :FormProps, 'cspace_config_untangler/form'
  autoload :Profile, 'cspace_config_untangler/profile'
  autoload :Extension, 'cspace_config_untangler/extensions'
  autoload :Extensions, 'cspace_config_untangler/extensions'
  autoload :RecordTypes, 'cspace_config_untangler/record_types'
  autoload :RecordType, 'cspace_config_untangler/record_types'
  autoload :SiteConfig, 'cspace_config_untangler/site_config'
  autoload :StructuredDateMessageGetter, 'cspace_config_untangler/structured_date_message_getter'
  autoload :StructuredDateField, 'cspace_config_untangler/structured_date_field'
  autoload :StructuredDateFieldMaker, 'cspace_config_untangler/structured_date_field_maker'
  
  def self.safe_copy(hash)
    Marshal.load(Marshal.dump(hash))
  end

  module TrackAttributes
    def attr_readers
      self.class.instance_variable_get('@attr_readers')
    end

    def self.included(klass)
      klass.send :define_singleton_method, :attr_reader, ->(*params) do
        @attr_readers ||= []
        @attr_readers.concat params
        super(*params)
      end
    end
  end

end
