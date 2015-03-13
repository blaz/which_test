module RangeSplit
  def split(into: 2, endianness: :big)
    raise ArgumentError, 'Cannot split in less than 1' if into < 1
    raise ArgumentError, 'The endianness parameter must be either :big
                          or :little' unless %i(big little).include? endianness

    return [self] if into == 1

    partition = min + (count.to_f / into).ceil - 1
    return [self] if max == partition

    partition -= 1 if endianness == :little
    partition = min if partition < min

    head = min..partition
    tail = ((partition+1)..max).split(into: into - 1, endianness: endianness)

    [head] + tail
  end
end

class Range
  include RangeSplit
end
