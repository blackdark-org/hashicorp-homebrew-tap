class Vagrant < Formula
  desc "Development environment"
  homepage "https://www.vagrantup.com/"
  version "2.3.6"

  def self.mirror
    ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")
  end

  url "#{mirror}/vagrant/#{version}/vagrant_#{version}_linux_amd64.zip"
  sha256 "71a616220e0f68d4882573afed4263a362eaafd14833a4f7e7c26f0cc0490157"

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
