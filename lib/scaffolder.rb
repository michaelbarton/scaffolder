require 'delegate'
require 'bio'

class Scaffolder
  autoload :Region,   'scaffolder/region'
  autoload :Insert,   'scaffolder/insert'
  autoload :Sequence, 'scaffolder/sequence'

  attr_reader :layout

  def initialize(assembly,sequence)
    @sequences = Hash[ *Bio::FlatFile::auto(sequence).collect { |s|
      [s.definition.split.first,s.seq]
    }.flatten]

    @layout = assembly.map do |entry|
      type, data = entry.keys.first, entry.values.first

      case type
      when 'unresolved'
        Scaffolder::Region.new(:unresolved,'N'*data['length'])
      when 'sequence'
        sequence = Scaffolder::Sequence.new(
          :name     => data['source'],
          :start    => data['start'],
          :end      => data['end'],
          :reverse  => data['reverse'],
          :sequence => fetch_sequence(data['source'])
        )
        if data['inserts']
          sequence.add_inserts(data['inserts'].map do |insert|
            Scaffolder::Insert.new(
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
    end
  end

  def fetch_sequence(name)
    sequence = @sequences[name]
    raise ArgumentError.new("Missing sequence: #{name}") unless sequence
    sequence
  end

end
