require 'cspace_config_untangler'

module CspaceConfigUntangler
  module Template
    class CsvTemplate
      ::CsvTemplate = CspaceConfigUntangler::Template::CsvTemplate
      attr_reader :csvdata

      # profile = string - name of profile
      # rectype = string - name of rectype to generate mapper for
      def initialize(profile:, rectype:)
        @profile = profile
        @rectype = rectype
        p = CCU::Profile.new(@profile, rectypes: [@rectype], structured_date_treatment: :collapse)
        @config = p.config
        @mappings = p.rectypes[0].fields.map{ |f| FieldMapper.new(field: f).mappings}.flatten
        @csvdata = []
        build_template
      end

      def write(dir)
        filename = "#{@profile}-#{@rectype}_template.csv"
        path = "#{File.expand_path(dir)}/#{filename}"
        CSV.open(path, 'wb') do |csv|
          @csvdata.each{ |r| csv << r }
        end
      end

      private

      def build_template
        requiredfields = @mappings.select{ |m| m.required == 'y' }
        otherfields = @mappings.select{ |m| m.required == 'n' }
        instruct = ['Before importing CSV, delete initial column and rows above the CSVHEADER row']
        required = ['REQUIRED']
        datatype = ['DATA TYPE']
        repeats = ['REPEATABLE FIELD?']
        group = ['IN REPEATING FIELD GROUP?']
        headers = ['CSVHEADER']
        
        [requiredfields, otherfields].each do |fieldmappings|
          fieldmappings.each do |mapping|
            instruct << ''
            headers << mapping.datacolumn
            datatype << mapping.data_type
            required << mapping.required
            repeats << mapping.repeats
            group << mapping.in_repeating_group
          end
        end

        @csvdata << instruct
        @csvdata << required
        @csvdata << datatype
        @csvdata << repeats
        @csvdata << group
        @csvdata << headers
      end
      
    end
  end
end #module