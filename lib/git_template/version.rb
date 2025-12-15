module GitTemplate
  VERSION = "1.0.0"
  
  # Validate semantic versioning format
  def self.valid_version?(version_string)
    version_string.match?(/\A\d+\.\d+\.\d+(?:-[a-zA-Z0-9\-\.]+)?(?:\+[a-zA-Z0-9\-\.]+)?\z/)
  end
  
  # Check if current version is valid
  def self.version_valid?
    valid_version?(VERSION)
  end
end