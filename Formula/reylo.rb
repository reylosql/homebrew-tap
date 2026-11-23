# Written by reylosql/reylo's release workflow (.github/scripts/channels.sh) for each release.
class Reylo < Formula
  desc "Infer types for SQL queries from the database itself"
  homepage "https://reylo.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.3/reylo-darwin-arm64.tar.gz"
      sha256 "b22b7bc2645f33c8ef1cb4790ecba2fc3075b092754e16ef044a4f55c711c96e"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.3/reylo-darwin-x64.tar.gz"
      sha256 "9eea8e03c4c3716c43d2e5dd350e03156b82ebf8f590c4cdfacd668d2cac1d69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.3/reylo-linux-arm64.tar.gz"
      sha256 "93dcbe0d2aab1aa71af6aa5446d1cf2edb7266e728ba58fa6c4a4da0b9270439"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.3/reylo-linux-x64.tar.gz"
      sha256 "2f89def8e4f13f0299ed81872665b36ebc0472cc13ff6d6f57e475d6dd519678"
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
