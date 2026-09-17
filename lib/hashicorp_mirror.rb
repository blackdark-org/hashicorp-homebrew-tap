module HashicorpMirror
  def self.url
    ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")
  end
end
