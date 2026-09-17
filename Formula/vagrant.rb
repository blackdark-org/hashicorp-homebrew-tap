class Vagrant < Formula
  desc "Development environment"
  homepage "https://www.vagrantup.com/"
  version "2.4.9"

  def self.mirror
    ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")
  end

  url "#{mirror}/vagrant/#{version}/vagrant_#{version}_linux_amd64.zip"
  sha256 "77d4d533c82c420b6b594992a902ec43fcd9f50380dc002a599e93fc744f8cfa"

  depends_on :linux
  depends_on arch: :x86_64

  conflicts_with "vagrant"

  def install
    bin.install "vagrant"
  end

  test do
    system "#{bin}/vagrant --version"
  end
end
