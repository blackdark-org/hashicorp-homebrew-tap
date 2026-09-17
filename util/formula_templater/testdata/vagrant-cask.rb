require_relative "../lib/hashicorp_mirror"

cask "hashicorp-vagrant" do
  version "2.3.6"

  on_macos do
    arch arm: "arm64", intel: "amd64"

    sha256 arm:   "4daf4d4c323cce7bf98065ecf5338e9800038a522cd81356c77555d9cd2f0db9",
           intel: "4daf4d4c323cce7bf98065ecf5338e9800038a522cd81356c77555d9cd2f0db9"

    url "#{HashicorpMirror.url}/vagrant/#{version}/vagrant_#{version}_darwin_#{arch}.dmg"

    pkg "vagrant.pkg"

    uninstall script:  {
                executable: "uninstall.tool",
                input:      ["Yes"],
                sudo:       true,
              },
              pkgutil: "com.vagrant.vagrant"

    zap trash: "~/.vagrant.d"
  end

  name "Vagrant"
  desc "Development environment"
  homepage "https://www.vagrantup.com/"

  depends_on :macos
end
