require "formula"

class Bocca < Formula
  homepage "http://www.cca-forum.org"
  url "http://www.cca-forum.org/download/cca-tools/cca-tools-latest/bocca-0.5.7.tar.gz"
  sha1 "9b996d3e4458d1b97713489a2ee5e1f9a270b12c"

  depends_on :python
  depends_on "babel"
  depends_on "cca-spec-babel"
  depends_on "ccaffeine"

  skip_clean "lib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bocca", "--version"
  end
end
