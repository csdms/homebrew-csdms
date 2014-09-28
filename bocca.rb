require "formula"

class Bocca < Formula
  homepage "http://www.cca-forum.org"
  url "http://www.cca-forum.org/download/cca-tools/cca-tools-latest/bocca-0.5.7.tar.gz"
  sha1 "9b996d3e4458d1b97713489a2ee5e1f9a270b12c"

  option "with-python=", "Path to a python binary" if OS.linux?

  depends_on :python unless OS.linux?
  depends_on "babel"
  depends_on "cca-spec-babel"
  depends_on "ccaffeine"

  skip_clean "lib"

  def install
    ENV.prepend_path 'PATH', File.dirname(which_babel_python)

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bocca", "--version"
  end

  def which_babel_python
    python = `babel-config --query-var=WHICH_PYTHON`.strip
    raise "python not found" unless File.exist? python
    return python
  end

  def which_python
    python = ARGV.value('with-python') || which('python').to_s
    raise "#{python} not found" unless File.exist? python
    return python
  end

end
