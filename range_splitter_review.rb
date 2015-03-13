# Put the custom method into a module and include it where needed
# in our case the built-in Range class (or *maybe* use refinements?)
class Range
  # Use ruby 2.0+ keyword arguments instead of an option hash
  def split(params = {})
    into = params[:into] || 2
    endianness = params[:endianness] || :big

    # Dump the excessive err variable and compact the line
    unless [:big, :little].include?(endianness)
      err = 'The endianness parameter must be either :big or :little'
      raise ArgumentError.new(err)
    end

    # Similiarly simplify this error check
    if into <= 0
      err = "Cannot split #{self} into #{into} ranges."
      raise ArgumentError.new(err)
    end

    # Remove unnecessary nesting and return explicitly
    if into == 1
      [self]
    else
      partition = min + (count.to_f / into).ceil - 1

      # Remove unnecessary nesting and return explicitly
      if max == partition
        [self]
      else
        args = params.merge(:into => into - 1)
        partition -= 1 if endianness == :little

        # Needs a check if partition is ever smaller than min element, otherwise
        # a bug crops up with a big into and little endianness
        head = min..partition
        tail = ((partition + 1)..max).split(args)

        [head] + tail
      end
    end
  end
end
