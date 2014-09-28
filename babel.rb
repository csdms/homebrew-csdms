require "formula"

class Babel < Formula
  version "1.4.0"
  homepage "http://computation.llnl.gov/casc/components"
  url "http://computation.llnl.gov/casc/components/docs/babel-1.4.0.tar.gz"
  sha1 "7dea34ace76b61ae76bf40e526734b1f23a7b11a"

  option "with-check", "Run tests before installing"
  option "with-java=", "Path to a java binary" if OS.linux?
  option "with-python=", "Path to a python binary" if OS.linux?

  depends_on :fortran
  depends_on :java unless OS.linux?
  depends_on :python unless OS.linux?
  depends_on "libxml2"
  depends_on "chasm"

  def install
    ENV['JAVAPREFIX'] = java_prefix

    ENV['CC'] = ENV.cc
    ENV['CXX'] = ENV.cxx
    ENV['F77'] = ENV['F90'] = ENV['F03'] = ENV['FC'] = ENV.fc
    ENV['JAVA'] = ENV['JAVAPREFIX'] + '/java'
    ENV['PYTHON'] = which_python
    ENV.append 'CFLAGS', "-std=gnu89"

    system "./configure", "--prefix=#{prefix}", "--disable-documentation",
      "--disable-java"

    system "make"
    system "make check" if build.with? "check"
    system "make", "install"

    rm Dir["#{share}/aclocal/libtool.m4"]
    rm Dir["#{share}/aclocal/ltdl.m4"]
  end

  test do
    system "#{bin}/babel", "--version"
    system "#{bin}/babel-config", "--query-var=BABEL_SUPPORTED_LANGUAGES"

    langs = %x[babel-config --query-var=BABEL_SUPPORTED_LANGUAGES].split()
    ['c', 'cxx', 'java', 'python', 'f77', 'f90', 'f03'].each do |lang|
      assert langs.include?(lang), "babel does not support #{lang}"
    end
  end

  def which_python
    python = ARGV.value('with-python') || which('python').to_s
    raise "#{python} not found" unless File.exist? python
    return python
  end

  def which_java
    java = ARGV.value('with-java') || which('java').to_s
    raise "java not found" unless File.exists? java
    return java
  end

  def java_prefix
    if OS.mac? then
      return  "#{`/usr/libexec/java_home`.chomp}"
    else
      return File.dirname(which_java)
    end
  end

end
