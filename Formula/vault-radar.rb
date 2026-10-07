require_relative "../lib/hashicorp_mirror"

class VaultRadar < Formula
  desc "Vault Radar"
  homepage "https://developer.hashicorp.com/hcp/docs/vault-radar/cli"
  version "0.55.0"

  if OS.mac? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/vault-radar/#{version}/vault-radar_#{version}_darwin_amd64.zip"
    sha256 "3e0b932e7b9a8bfd0d91e8bffce76a4907e1f0239fc3be495deaf9795fca4bfe"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{HashicorpMirror.url}/vault-radar/#{version}/vault-radar_#{version}_darwin_arm64.zip"
    sha256 "86f7337f170caf5e2f4d9f75378efacc3491e7beaf81c9b17f72314639cad33c"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/vault-radar/#{version}/vault-radar_#{version}_linux_amd64.zip"
    sha256 "47b07cbafa43b660152fba2e6a62657f5fd34d8e6aea4a3b425778c0d1bbbaff"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{HashicorpMirror.url}/vault-radar/#{version}/vault-radar_#{version}_linux_arm64.zip"
    sha256 "893cef1ce989a6285cdd29535d078149ce84638d5d312f997b23c2802380f7c4"
  end

  conflicts_with "vault-radar"

  def install
    bin.install "vault-radar"
  end

  test do
    system "#{bin}/vault-radar --version"
  end
end
