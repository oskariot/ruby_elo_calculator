class String
  def is_i?
    self.to_i.to_s == self
  end

  def is_f?
    !!Float(self) rescue false
  end
end