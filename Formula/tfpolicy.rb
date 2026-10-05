require_relative "../lib/hashicorp_mirror"

class Tfpolicy < Formula
  desc "Terraform Policy"
  homepage "https://developer.hashicorp.com/terraform/policy/reference/cli"
  version "0.4.0"

  if OS.mac? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/tfpolicy/#{version}/tfpolicy_#{version}_darwin_amd64.zip"
    sha256 "0d3ba8197fcec7fcc472cb93aa4abdfdbeeefb05c2ea772d59486ce2366c4d37"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{HashicorpMirror.url}/tfpolicy/#{version}/tfpolicy_#{version}_darwin_arm64.zip"
    sha256 "429a0805fcf301bab68f66abc3298683485beac0d87253ace489ec6dee5773eb"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/tfpolicy/#{version}/tfpolicy_#{version}_linux_amd64.zip"
    sha256 "67675d68f052e52d503248d6108346844f0708540a41cfd03be2b4ee22a03052"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "#{HashicorpMirror.url}/tfpolicy/#{version}/tfpolicy_#{version}_linux_arm.zip"
    sha256 "8771746cc5dfe86ff3059d1fa4cd819c8ac888f3fc55207a44a52088ad9116de"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{HashicorpMirror.url}/tfpolicy/#{version}/tfpolicy_#{version}_linux_arm64.zip"
    sha256 "3c4f617c2bfde00c377435ebd11fa016f68347ee1f692f44aae780cb6135acc1"
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
