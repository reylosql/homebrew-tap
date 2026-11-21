# Written by reylosql/reylo's release workflow (.github/scripts/channels.sh) for each release.
class Reylo < Formula
  desc "Infer types for SQL queries from the database itself"
  homepage "https://reylo.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.0/reylo-darwin-arm64.tar.gz"
      sha256 "38576b8c00403b4b4ba1a69c887b5322b7fb3bd7191ba105f41731759dbd6a1b"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.0/reylo-darwin-x64.tar.gz"
      sha256 "97b44749a45d187d669bd7fbfb4d1b8dd9ee2b49f776dfbfda54e00303608125"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.0/reylo-linux-arm64.tar.gz"
      sha256 "01875a6ab7305a94672906218500f2a5305b5a891b12af906716cd243b9b04ba"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.0/reylo-linux-x64.tar.gz"
      sha256 "11c8a0747b65e534bf7095535274eb16ecd590c9dcc3b82b4bd58a2c1545d45a"
    end
  end

  def install
    bin.install "reylo"
  end

  test do
    assert_match "reylo #{version}", shell_output("#{bin}/reylo --version")
    (testpath/"app.db").write ""
    system bin/"reylo", "run", "create table users (id integer primary key, email text not null) strict",
           "--url", "sqlite:#{testpath}/app.db"
    assert_match '"cardinality":"many"',
                 shell_output("#{bin}/reylo analyze --sql 'select email from users' " \
                              "--url sqlite:#{testpath}/app.db --format json")
  end
end
