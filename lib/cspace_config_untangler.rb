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
  CCU.const_set('MAINPROFILE', 'core_6_0_0')
  CCU.const_set('DATADIR', '/Users/kristina/code/cspace-config-untangler/data')
  CCU.const_set('CONFIGDIR', "#{CCU::DATADIR}/configs")
  CCU.const_set('SITECONFIG', "#{CCU::DATADIR}/profile_config.yaml")
  config_file_names = Dir.new(CCU::CONFIGDIR).children
    .reject{ |e| e['readable'] }
    .reject{ |e| e == '.keep' }
    .map{ |fn| File.basename(fn).sub('.json', '') }
  CCU.const_set('PROFILES', config_file_names)
  File.delete('log.log') if File::exist?('log.log')
  CCU.const_set('LOG', Logger.new('log.log'))

  autoload :VERSION, 'cspace_config_untangler/version'
  autoload :CommandLine, 'cspace_config_untangler/command_line'

  # extracting field data from JSON config
  autoload :Field, 'cspace_config_untangler/field'
  autoload :FieldDefinitionParser, 'cspace_config_untangler/field_definition_parser'
  autoload :FieldDefinition, 'cspace_config_untangler/field_definition_parser'
  autoload :FieldVerifier, 'cspace_config_untangler/field_definition_parser'
  autoload :Form, 'cspace_config_untangler/form'
  autoload :FormProps, 'cspace_config_untangler/form'
  autoload :Profile, 'cspace_config_untangler/profile'
  autoload :ProfileComparison, 'cspace_config_untangler/profile_comparison'
  autoload :Extension, 'cspace_config_untangler/extensions'
  autoload :Extensions, 'cspace_config_untangler/extensions'
  autoload :RecordTypes, 'cspace_config_untangler/record_types'
  autoload :RecordType, 'cspace_config_untangler/record_types'
  autoload :SiteConfig, 'cspace_config_untangler/site_config'
  autoload :StructuredDateMessageGetter, 'cspace_config_untangler/structured_date_message_getter'
  autoload :StructuredDateField, 'cspace_config_untangler/structured_date_field'
  autoload :StructuredDateFieldMaker, 'cspace_config_untangler/structured_date_field_maker'

  # mapping CSV data to CSpace XML
  autoload :FieldMap, 'cspace_config_untangler/field_map'
  autoload :FieldMapper, 'cspace_config_untangler/field_map'
  autoload :FieldMapping, 'cspace_config_untangler/field_map'
  autoload :AuthorityConfigLookup, 'cspace_config_untangler/field_map'
  autoload :CsvMapper, 'cspace_config_untangler/csv_mapper'
  autoload :RecordMapper, 'cspace_config_untangler/record_mapper'
  autoload :RecordMapping, 'cspace_config_untangler/record_mapper'
  autoload :NamespaceUris, 'cspace_config_untangler/record_mapper'
  autoload :RowMapper, 'cspace_config_untangler/row_mapper'
  
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
