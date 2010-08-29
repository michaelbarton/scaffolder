class Scaffolder::Base
  class Sequence

    def valid?
      errors.empty?
    end

    def errors
      @inserts.inject(Array.new) do |error_set,a|
        @inserts.each do |b|
          next if a.equal?(b)
          error_set << [a,b].sort if a.overlap?(b)
        end
        error_set
      end.uniq
    end

  end
end
