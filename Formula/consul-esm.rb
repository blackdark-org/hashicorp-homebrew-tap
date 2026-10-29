require_relative "../lib/hashicorp_mirror"

class ConsulEsm < Formula
  desc "Consul ESM"
  homepage "https://github.com/hashicorp/consul-esm"
  version "0.11.2"

  if OS.mac? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/consul-esm/#{version}/consul-esm_#{version}_darwin_amd64.zip"
    sha256 "93f16f271d349144c8a2ee4e4d898ef87c44c671ca345a843e32c04368495acc"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{HashicorpMirror.url}/consul-esm/#{version}/consul-esm_#{version}_darwin_arm64.zip"
    sha256 "4513bdb885c865016ea19dd1b674b4e1855f2d9346ca8707a84f66a4b99d9196"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/consul-esm/#{version}/consul-esm_#{version}_linux_amd64.zip"
    sha256 "40ed9598e1ba4d4f46217435fad98427d845dc8adf28d770549ad4f0e27bfd85"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "#{HashicorpMirror.url}/consul-esm/#{version}/consul-esm_#{version}_linux_arm.zip"
    sha256 "86b056e9e26c9c815b263d05057d7e7480861ea3d7d84e827b65e5ee6eb72107"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{HashicorpMirror.url}/consul-esm/#{version}/consul-esm_#{version}_linux_arm64.zip"
    sha256 "9fd5f0c90a6778275a5ba0738ca84fe7970cce9499b0b7afc9d7d8b052bf5682"
  end

  conflicts_with "consul-esm"

  def install
    bin.install "consul-esm"
  end

  test do
    system "#{bin}/consul-esm --version"
  end
end
