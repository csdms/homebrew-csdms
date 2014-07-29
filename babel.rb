require "formula"

class Babel < Formula
  version "1.4.0"
  homepage "http://computation.llnl.gov/casc/components"
  url "http://computation.llnl.gov/casc/components/docs/babel-1.4.0.tar.gz"
  sha1 "7dea34ace76b61ae76bf40e526734b1f23a7b11a"

  option "with-check", "Run tests before installing"

  depends_on :java
  depends_on :python
  depends_on "libxml2"
  depends_on "chasm"
  depends_on "gcc"

  def install
    ENV['JAVAPREFIX'] = "#{`/usr/libexec/java_home`.chomp}"

    ENV['CC'] = "cc"
    ENV['CXX'] = "c++"
    ENV['FC'] = "gfortran"
    ENV['F77'] = "gfortran"
    ENV['CFLAGS'] = "-std=gnu89"

    system "./configure", "--prefix=#{prefix}", "--disable-documentation"

    system "make"
    system "make check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/babel", "--version"
  end
end
