require "formula"

class Babel20 < Formula
  homepage "http://computation.llnl.gov/casc/components"
  url "http://computation.llnl.gov/casc/components/docs/babel-2.0.0.tar.gz"
  sha1 "e60d0ad140e8248d2c18dededbf33077bfdf6b2f"

  option "with-check", "Run tests before installing"

  # depends_on "cmake" => :build
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
  end
end
