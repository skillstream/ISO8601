# encoding: utf-8

module ISO8601
  ##
  # A Years atom in a {ISO8601::Duration}
  #
  # A "calendar year" is the cyclic time interval in a calendar which is
  # required for one revolution of the Earth around the Sun and approximated to
  # an integral number of "calendar days".
  #
  # A "duration year" is the duration of 365 or 366 "calendar days" depending
  # on the start and/or the end of the corresponding time interval within the
  # specific "calendar year".
  class Years
    include Atomic

    ##
    # The "duration year" average is calculated through time intervals of 400
    # "duration years". Each cycle of 400 "duration years" has 303 "common
    # years" of 365 "calendar days" and 97 "leap years" of 366 "calendar days".
    AVERAGE_FACTOR = ((365 * 303 + 366 * 97) / 400) * 86400

    ##
    # @param [Numeric] atom The atom value
    # @param [ISO8601::DateTime, nil] base (nil) The base datetime to compute
    #   the atom factor.
    def initialize(atom)
      validate_atom(atom)

      @atom = atom
    end

    ##
    # The Year factor
    #
    # @return [Integer]
    def factor(base = nil)
      validate_base(base)

      return AVERAGE_FACTOR if base.nil?
      return adjusted_factor(1, base) if atom.zero?

      adjusted_factor(atom, base)
    end

    def adjusted_factor(atom, base)
      (::Time.utc((base.year + atom).to_i) - ::Time.utc(base.year)) / atom
    end

    ##
    # The amount of seconds
    #
    # @return [Numeric]
    def to_seconds(base = nil)
      validate_base(base)

      return (AVERAGE_FACTOR * atom) if base.nil?

      ::Time.utc(year(atom, base)) - ::Time.utc(base.year)
    end

    ##
    # The atom symbol.
    #
    # @return [Symbol]
    def symbol
      :Y
    end

    private

    def validate_base(base)
      fail ISO8601::Errors::TypeError,
           "The base argument for #{self.class} should be a ISO8601::DateTime instance or nil." unless base.is_a?(ISO8601::DateTime) || base.nil?
    end


    def year(atom, base)
      (base.year + atom).to_i
    end
  end
end
