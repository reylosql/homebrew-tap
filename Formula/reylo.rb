# Written by reylosql/reylo's release workflow (.github/scripts/channels.sh) for each release.
class Reylo < Formula
  desc "Infer types for SQL queries from the database itself"
  homepage "https://reylo.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.9.0/reylo-darwin-arm64.tar.gz"
      sha256 "9932473e30f32683c5b0da4826c3c262bc98a5ad4d81bf4ab2b313796df1d331"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.9.0/reylo-darwin-x64.tar.gz"
      sha256 "23b2a800cae424443cb6534efffd69d0b1e41d276e8d98d5c2968d458d31c897"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.9.0/reylo-linux-arm64.tar.gz"
      sha256 "7185a6f866b0ac65eba2bcf0dc7821ce60b36225d37f6988301a0960e26853db"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.9.0/reylo-linux-x64.tar.gz"
      sha256 "f573882ac608e7b46bcb01304d6e329c8b419efccf7fc571209c18f8915cdb95"
    end
  end

  def install
    bin.install "reylo"
    prefix.install Dir["LICENSE*", "NOTICE.md"]
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
