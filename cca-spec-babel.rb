require "formula"

class CcaSpecBabel < Formula
  homepage "http://www.cca-forum.org"
  url "http://www.cca-forum.org/download/cca-tools/cca-tools-latest/cca-spec-babel-0.8.6.tar.gz"
  sha1 "a149b96bd9945b2813d32467cafc9e7fe59d4248"

  depends_on :fortran
  depends_on "libxml2"
  depends_on "babel"

  def install
    system "./configure", "--disable-contrib",
      "--with-babel-config=#{HOMEBREW_PREFIX}/bin/babel-config",
      "--with-libxml2=#{HOMEBREW_PREFIX}/opt/libxml2",
      "--prefix=#{prefix}"

    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/cca-spec-babel-config", "--version"
  end
end
