require "formula"

class Boccatools < Formula
  version "0.1"
  homepage "https://csdms.colorado.edu"
  url "https://csdms.colorado.edu/svn/bocca_tools/trunk", :using => :svn
  sha1 ""

  depends_on :python
  depends_on "bocca"

  def install
    ENV.prepend_create_path "PYTHONPATH", prefix + "lib/#{python_version}/site-packages"

    system "python", "setup.py", "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    ENV['PYTHONPATH'] = prefix + "lib/#{python_version}/site-packages"
    system "python", "-c", "import bocca"
    system "#{bin}/bocca-build", "-h"
    system "#{bin}/bocca-save", "-h"
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
