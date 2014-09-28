require "formula"

class Boccatools < Formula
  version "0.1"
  homepage "https://csdms.colorado.edu"
  url "https://csdms.colorado.edu/svn/bocca_tools/trunk", :using => :svn
  sha1 ""

  option "with-python=", "Path to a python binary" if OS.linux?

  depends_on :python unless OS.linux?
  depends_on "bocca"

  def install
    ENV.prepend_path 'PATH', File.dirname(which_babel_python)

    ENV.prepend_create_path "PYTHONPATH", prefix + "lib/#{python_version}/site-packages"

    system "python", "setup.py", "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    ENV.prepend_path 'PATH', File.dirname(which_babel_python)
    ENV['PYTHONPATH'] = prefix + "lib/#{python_version}/site-packages"
    system "python", "-c", "import bocca"
    system "#{bin}/bocca-build", "-h"
    system "#{bin}/bocca-save", "-h"
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

  def python_version
    "python" + `python -c 'import sys; print(sys.version[:3])'`.strip
  end

  def caveats; <<-EOS.undent
    Set the PYTHONPATH environment variable:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{python_version}/site-packages
    EOS
  end
end
