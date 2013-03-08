require "security_release_practice/version"

module SecurityReleasePractice
  def super_secure_calculation(input)
    input.to_sym
    input.to_i + 6
  end

  def another_new_calculation(input)
    input.to_s + ", lol."
  end
end
