require_relative "../lib/hashicorp_mirror"

class NomadEnterprise < Formula
  desc "Nomad Enterprise"
  homepage "https://www.nomadproject.io/"
  version "2.1.0+ent"

  if OS.mac? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/nomad/#{version}/nomad_#{version}_darwin_amd64.zip"
    sha256 "2339ac7314cf03e0fa8db1d2a6e025196de7a4857f45aa7b33b277675e0762c8"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "#{HashicorpMirror.url}/nomad/#{version}/nomad_#{version}_darwin_arm64.zip"
    sha256 "4c77e095679c5e16365be50c722c32da88490746d24118c9fd9bd88612bd225b"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "#{HashicorpMirror.url}/nomad/#{version}/nomad_#{version}_linux_amd64.zip"
    sha256 "94ec1812b49c577b15cd3b83cfc14597b78d5d984dca3af7d35832735997ef30"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "#{HashicorpMirror.url}/nomad/#{version}/nomad_#{version}_linux_arm64.zip"
    sha256 "40fb915220f6e0ef25b8f6f0993aca186115c3ea544ff8049144b22196b73ce7"
  end

  conflicts_with "nomad-enterprise"

  def install
    bin.install "nomad"

    # The binary completes itself when invoked with COMP_LINE set, rather than
    # emitting a script, so these mirror what -autocomplete-install writes to rc files.
    (bash_completion/"nomad").write "complete -C #{opt_bin}/nomad nomad\n"
    (zsh_completion/"_nomad").write <<~EOS
      #compdef nomad
      local -a matches
      matches=( ${(f)"$(COMP_LINE="$words" COMP_POINT=$(( 1 + ${#${(j. .)words[1,CURRENT-1]}} + $#PREFIX )) #{opt_bin}/nomad)"} )
      compadd -Q -S '' -a matches
    EOS
    (fish_completion/"nomad.fish").write <<~EOS
      function __complete_nomad
          set -lx COMP_LINE (commandline -cp)
          test -z (commandline -ct)
          and set COMP_LINE "$COMP_LINE "
          #{opt_bin}/nomad
      end
      complete -f -c nomad -a "(__complete_nomad)"
    EOS
  end

  service do
    run [bin/"nomad", "agent", "-dev"]
    keep_alive successful_exit: false
    working_dir var
    log_path var/"log/nomad.log"
    error_log_path var/"log/nomad.log"
  end

  test do
    system "#{bin}/nomad --version"
  end
end
