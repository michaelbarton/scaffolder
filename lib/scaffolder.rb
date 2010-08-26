require 'delegate'
require 'bio'

class Scaffolder < DelegateClass(Array)
  autoload :Base, 'scaffolder/base'

  def initialize(assembly,sequence)
    @sequences = Hash[ *Bio::FlatFile::auto(sequence).collect { |s|
      [s.definition.split.first,s.seq]
    }.flatten]

    super(assembly.map do |entry|
      type, data = entry.keys.first, entry.values.first

      case type
      when 'unresolved'
        Scaffolder::Base::Region.new(:unresolved,'N'*data['length'])
      when 'sequence'
        sequence = Scaffolder::Base::Sequence.new(
          :name     => data['source'],
          :start    => data['start'],
          :end      => data['end'],
          :reverse  => data['reverse'],
          :sequence => fetch_sequence(data['source'])
        )
        if data['inserts']
          sequence.add_inserts(data['inserts'].map do |insert|
            Scaffolder::Base::Insert.new(
              :start    => insert['start'],
              :stop     => insert['stop'],
              :sequence => fetch_sequence(insert['source'])
            )
          end)
        end
        sequence
      else
        raise ArgumentError.new("Unknown tag: #{type}")
      end
    end)
  end

  def fetch_sequence(name)
    sequence = @sequences[name]
    raise ArgumentError.new("Missing sequence: #{name}") unless sequence
    sequence
  end

end
