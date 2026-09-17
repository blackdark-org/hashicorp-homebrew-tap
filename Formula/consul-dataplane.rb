class ConsulDataplane < Formula
  desc "Consul Dataplane"
  homepage "https://github.com/hashicorp/consul-dataplane"
  version "2.0.4"

  def self.mirror
    ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")
  end

  if OS.mac? && Hardware::CPU.intel?
    url "#{mirror}/consul-dataplane/#{version}/consul-dataplane_#{version}_darwin_amd64.zip"
    sha256 "623bb15ed680dd22e630bb1e1de7f3ad73542782a38e90969a2f52057af70ef8"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{mirror}/consul-dataplane/#{version}/consul-dataplane_#{version}_darwin_arm64.zip"
    sha256 "c440ac1f75828ef532ed8ffe9b6c4116391730cb3ae3fe361072db61b1b010b1"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{mirror}/consul-dataplane/#{version}/consul-dataplane_#{version}_linux_amd64.zip"
    sha256 "03431be5616ffeffe64a52cebca04891097ee00a3f6b4878028140ed108bcd16"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "#{mirror}/consul-dataplane/#{version}/consul-dataplane_#{version}_linux_arm.zip"
    sha256 "03e0093d819a43124643f2e22f176a66443249358665dcbf366414aab4ea452c"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{mirror}/consul-dataplane/#{version}/consul-dataplane_#{version}_linux_arm64.zip"
    sha256 "3395c124ea81eeeccf052c831bdbca3b74ea1efd0a68e5ec9080473f5bdc5653"
  end
  
  depends_on "envoy" => :recommended

  conflicts_with "consul-dataplane"

  def install
    bin.install "consul-dataplane"
  end

  test do
    system "#{bin}/consul-dataplane --version"
  end
end
