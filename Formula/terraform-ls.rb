class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  version "0.39.0"

  def self.mirror
    ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")
  end

  if OS.mac? && Hardware::CPU.intel?
    url "#{mirror}/terraform-ls/#{version}/terraform-ls_#{version}_darwin_amd64.zip"
    sha256 "cc5bbc5b5a39d12d455c0d2b1e4b3a2c1f237d02d2cf819cf5252358f2d674de"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{mirror}/terraform-ls/#{version}/terraform-ls_#{version}_darwin_arm64.zip"
    sha256 "6f80fe0b34af184175508f3d9135d8159f5dce4000d9b39540553eb1c267c54b"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{mirror}/terraform-ls/#{version}/terraform-ls_#{version}_linux_amd64.zip"
    sha256 "7750edc736845fd8c04ff0fc6332423c12d8275b358668c8c17e8aedc43ef971"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "#{mirror}/terraform-ls/#{version}/terraform-ls_#{version}_linux_arm.zip"
    sha256 "cfb11bb8c23801def22f06091330b1ec72b7df567971fd997e8aa656b3105f20"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{mirror}/terraform-ls/#{version}/terraform-ls_#{version}_linux_arm64.zip"
    sha256 "62f32ea22cb78e5e5667ed638ad6e0fbde30ab59228d073c3c9bb249f89c7f5a"
  end

  conflicts_with "terraform-ls"

  def install
    bin.install "terraform-ls"
  end

  test do
    system "#{bin}/terraform-ls --version"
  end
end
