class Scaffolder

  def valid?
    errors.empty?
  end

  def errors
    sequences = layout.select{|i| i.entry_type == :sequence}
    sequences.select{|s| s.valid? == false}
  end

end
