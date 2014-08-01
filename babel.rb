require "formula"

class Babel < Formula
  version "1.4.0"
  homepage "http://computation.llnl.gov/casc/components"
  url "http://computation.llnl.gov/casc/components/docs/babel-1.4.0.tar.gz"
  sha1 "7dea34ace76b61ae76bf40e526734b1f23a7b11a"

  option "with-check", "Run tests before installing"

  depends_on :java
  depends_on :python
  depends_on :fortran
  depends_on "libxml2"
  depends_on "chasm"

  def install
    ENV['JAVAPREFIX'] = "#{`/usr/libexec/java_home`.chomp}"

    ENV['CC'] = '/usr/bin/clang'
    ENV['CXX'] = '/usr/bin/clang++'
    ENV['F77'] = ENV['F90'] = ENV['F03'] = ENV['FC']
    ENV['JAVA'] = ENV['JAVAPREFIX'] + '/bin/java'
    ENV.append 'CFLAGS', "-std=gnu89"

    system "./configure", "--prefix=#{prefix}", "--disable-documentation"

    system "make"
    system "make check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/babel", "--version"
    system "#{bin}/babel-config", "--query-var=BABEL_SUPPORTED_LANGUAGES"

    langs = %x[babel-config --query-var=BABEL_SUPPORTED_LANGUAGES].split()
    ['c', 'cxx', 'java', 'python', 'f77', 'f90', 'f03'].each do |lang|
      assert langs.include?(lang), "babel does not support #{lang}"
    end
  end
end
