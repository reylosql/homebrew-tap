# Written by reylosql/reylo's release workflow (.github/scripts/channels.sh) for each release.
class Reylo < Formula
  desc "Infer types for SQL queries from the database itself"
  homepage "https://reylo.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.2/reylo-darwin-arm64.tar.gz"
      sha256 "6e451f119f7bc249a92b14c592bbd4c75e3307fa16067bcb86740f52d0e4e986"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.2/reylo-darwin-x64.tar.gz"
      sha256 "f56e30c591f1722183233054b9e5e663f00fe5dfbf02cf8b3a83a9d7e13885e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.2/reylo-linux-arm64.tar.gz"
      sha256 "76813b59035c913ce1bb007e07f76bab00c59e53c8d3142fd8d1b01875da056d"
    end
    on_intel do
      url "https://github.com/reylosql/reylo/releases/download/v0.8.2/reylo-linux-x64.tar.gz"
      sha256 "9bc11ae9ea6c27e92928304ac6db5e77537187e1e98f2532b7652e03827d06e5"
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
