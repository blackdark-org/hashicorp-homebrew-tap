class Hcp < Formula
  desc "HCP CLI"
  homepage "https://github.com/hashicorp/hcp"
  version "0.11.0"

  def self.mirror
    ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")
  end

  if OS.mac? && Hardware::CPU.intel?
    url "#{mirror}/hcp/#{version}/hcp_#{version}_darwin_amd64.zip"
    sha256 "5dc1d68c848eebf33a8897885f51ba243b82abe2f5db6546b404729b7bfbe6a4"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{mirror}/hcp/#{version}/hcp_#{version}_darwin_arm64.zip"
    sha256 "064fb59443d437d71a532ae054ba888fe993ce34164cb858c54ea416226a2417"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{mirror}/hcp/#{version}/hcp_#{version}_linux_amd64.zip"
    sha256 "09a0d2bd8a8834907e162188c4d68468824444aca163b28b8c38ba63749fb052"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "#{mirror}/hcp/#{version}/hcp_#{version}_linux_arm.zip"
    sha256 "15f8eae1b4abc91f4a03380b583503304cd16e5cad468845c34c1eb67766daa3"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{mirror}/hcp/#{version}/hcp_#{version}_linux_arm64.zip"
    sha256 "2a2528756df22dbab5cfb0645ae3098c811a5f033c9a98e6171c6aa8f728bf5e"
  end

  conflicts_with "hcp"

  def install
    bin.install "hcp"

    # The binary completes itself when invoked with COMP_LINE set, rather than
    # emitting a script, so these mirror what -autocomplete-install writes to rc files.
    (bash_completion/"hcp").write "complete -C #{opt_bin}/hcp hcp\n"
    (zsh_completion/"_hcp").write <<~EOS
      #compdef hcp
      local -a matches
      matches=( ${(f)"$(COMP_LINE="$words" COMP_POINT=$(( 1 + ${#${(j. .)words[1,CURRENT-1]}} + $#PREFIX )) #{opt_bin}/hcp)"} )
      compadd -Q -S '' -a matches
    EOS
    (fish_completion/"hcp.fish").write <<~EOS
      function __complete_hcp
          set -lx COMP_LINE (commandline -cp)
          test -z (commandline -ct)
          and set COMP_LINE "$COMP_LINE "
          #{opt_bin}/hcp
      end
      complete -f -c hcp -a "(__complete_hcp)"
    EOS
  end

  test do
    system "#{bin}/hcp version"
  end
end
