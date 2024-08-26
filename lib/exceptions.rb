# frozen_string_literal: true

class InvalidMove < StandardError
  def initialize(msg = 'That is an invalid move', exception_type = 'custom')
    @exception_type = exception_type
    super(msg)
  end
end
