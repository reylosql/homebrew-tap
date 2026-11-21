# Written by reylosql/reylo's release workflow (.github/scripts/channels.sh) for each release.
class Reylo < Formula
  desc "Infer types for SQL queries from the database itself"
  homepage "https://reylo.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.1/reylo-darwin-arm64.tar.gz"
      sha256 "4a73d5df53e318401cd7ac4a273e7cd347639ac899ebfe17527889a2d9007cb6"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.1/reylo-darwin-x64.tar.gz"
      sha256 "36cc7a64d680a07b25dbde3396f28acc9a1fda994915ebf5d9112ad6409fe9b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.1/reylo-linux-arm64.tar.gz"
      sha256 "509c9b3fc6596c0270148b7c9a05e8b44c395c94cb5b7642d710f95f3de73c07"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.1/reylo-linux-x64.tar.gz"
      sha256 "bae55de1f849a44fd2153fa46c6b7a5da0dab4aaebfcaaeda3cbd325aaa59d53"
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
