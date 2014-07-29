require "formula"

class CcaSpecBabel < Formula
  homepage "http://www.cca-forum.org"
  url "http://www.cca-forum.org/download/cca-tools/cca-tools-latest/cca-spec-babel-0.8.6.tar.gz"
  sha1 "a149b96bd9945b2813d32467cafc9e7fe59d4248"

  depends_on "libxml2"
  depends_on "gcc"
  depends_on "babel"

  def install
    ENV['CC'] = "cc"
    ENV['CXX'] = "c++"
    ENV['FC'] = "gfortran"
    ENV['F77'] = "gfortran"

    system "./configure", "--disable-contrib",
      "--with-babel-config=#{HOMEBREW_PREFIX}/bin/babel-config",
      "--with-libxml2=/usr/local/opt/libxml2",
      "--prefix=#{prefix}"

    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/usr/local/bin/cca-spec-babel-config", "--version"
  end
end
