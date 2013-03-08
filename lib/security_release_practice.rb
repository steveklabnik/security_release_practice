require "security_release_practice/version"

module SecurityReleasePractice
  def super_secure_calculation(input)
    input.to_sym
    input.to_i + 5
  end
end
