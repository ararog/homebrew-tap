class Uget < Formula
  desc "A minimal cli tool to make http requests. You want, you get!"
  homepage "https://github.com/ararog/deboa"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ararog/deboa/releases/download/0.1.2/uget-aarch64-apple-darwin.tar.xz"
      sha256 "1f15ff1f2387f5c0f5722bf5d4af0089a1922b50c52498a0457325c4da0e3497"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ararog/deboa/releases/download/0.1.2/uget-x86_64-apple-darwin.tar.xz"
      sha256 "c0097cecc4bff85b96a7b3f8803c700a88e0cebff2e90487e2dc6709f121d87d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ararog/deboa/releases/download/0.1.2/uget-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "363fc252560e1a1bdd4051ed222e7dfae8f0f07d35f760c4d6d9afaffc366478"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ararog/deboa/releases/download/0.1.2/uget-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c53786c182aa4cad4e60935488afbb10a7b51e601f02eb58ec0364af50719c06"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "uget" if OS.mac? && Hardware::CPU.arm?
    bin.install "uget" if OS.mac? && Hardware::CPU.intel?
    bin.install "uget" if OS.linux? && Hardware::CPU.arm?
    bin.install "uget" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
