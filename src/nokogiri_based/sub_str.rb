require_relative './element_not_found.rb'

module StringScannerBased
  # ATTENTION
  # there is a lazy evaluation
  # so if you need to move pointer immediately
  # you need send .to_s
  # otherwise send nothing
  # I need this class since I need stop scanner in case no open_pattern was found
  SubStr = Data.define(:scanner, :open_pattern, :close_pattern) do
    def to_s = value

    private

      def value
        scanner.skip_until(open_pattern) || raise(ElementNotFound.new(open_pattern))
        scanner.scan_until(close_pattern)
      end

      def method_missing(name, ...) = value.send(name, ...)
  end

  private_constant :SubStr
end