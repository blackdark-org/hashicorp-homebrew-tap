class Tfpolicy < Formula
  desc "Terraform Policy"
  homepage "https://developer.hashicorp.com/terraform/policy/reference/cli"
  version "0.3.0"

  def self.mirror
    ENV.fetch("HOMEBREW_HASHICORP_TAP_MIRROR", "https://releases.hashicorp.com")
  end

  if OS.mac? && Hardware::CPU.intel?
    url "#{mirror}/tfpolicy/#{version}/tfpolicy_#{version}_darwin_amd64.zip"
    sha256 "28f889605da65a6ab30450984a38fa5a8238678645862947b9e84099cd46eb37"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{mirror}/tfpolicy/#{version}/tfpolicy_#{version}_darwin_arm64.zip"
    sha256 "2c1eada37c99ed760dc9c62d4062ecf8df2262dc5824b9042cd73681886a6abe"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{mirror}/tfpolicy/#{version}/tfpolicy_#{version}_linux_amd64.zip"
    sha256 "d62e2077184326f1c6063e90c4f4497d0cf5ac1fd66bfec5ca35f5dabd757379"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "#{mirror}/tfpolicy/#{version}/tfpolicy_#{version}_linux_arm.zip"
    sha256 "fe6f5ad976ef25ec4e0a8877c3c4a5ab8d158dadd79345ff7edbc70b199a6e72"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{mirror}/tfpolicy/#{version}/tfpolicy_#{version}_linux_arm64.zip"
    sha256 "b1153abe3b587b61f3b245acc4efa1406a7c1bcc7d1be92ba694349f70d4a8d3"
  end

  conflicts_with "tfpolicy"

  def install
    bin.install "tfpolicy"

    # The binary completes itself when invoked with COMP_LINE set, rather than
    # emitting a script, so these mirror what -autocomplete-install writes to rc files.
    (bash_completion/"tfpolicy").write "complete -C #{opt_bin}/tfpolicy tfpolicy\n"
    (zsh_completion/"_tfpolicy").write <<~EOS
      #compdef tfpolicy
      local -a matches
      matches=( ${(f)"$(COMP_LINE="$words" COMP_POINT=$(( 1 + ${#${(j. .)words[1,CURRENT-1]}} + $#PREFIX )) #{opt_bin}/tfpolicy)"} )
      compadd -Q -S '' -a matches
    EOS
    (fish_completion/"tfpolicy.fish").write <<~EOS
      function __complete_tfpolicy
          set -lx COMP_LINE (commandline -cp)
          test -z (commandline -ct)
          and set COMP_LINE "$COMP_LINE "
          #{opt_bin}/tfpolicy
      end
      complete -f -c tfpolicy -a "(__complete_tfpolicy)"
    EOS
  end

  test do
    system "#{bin}/tfpolicy --version"
  end
end
