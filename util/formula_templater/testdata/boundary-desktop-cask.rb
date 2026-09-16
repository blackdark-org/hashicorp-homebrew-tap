cask "hashicorp-boundary-desktop" do
  version "1.6.0"

  on_macos do
    sha256 "b6b5b15dfb469b7fdab9216788f5931e96561104de1ff7f9e0d6fda54701be09"

    url "#{ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")}/boundary-desktop/#{version}/boundary-desktop_#{version}_darwin_amd64.dmg"

    app "Boundary.app"
  end

  name "Boundary Desktop"
  desc "Desktop client for Boundary"
  homepage "https://www.boundaryproject.io/"

  depends_on :macos
end
