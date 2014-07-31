require "formula"

class Cmi < Formula
  version "0.1"
  homepage "http://csdms.colorado.edu"
  url "https://github.com/csdms/cmi", :using => :git
  sha1 ""

  depends_on "babel"
  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'bocca' => :build
  depends_on 'boccatools' => :build
  depends_on 'child'
  depends_on 'sedflux'
  depends_on 'glib'
  depends_on 'hydrotrend'
  depends_on 'cem'

  def install
    ENV.deparallelize

    models = %w{child cem plume waves hydrotrend sedflux2d sedflux3d}
    models.each do |model|
      ENV["#{model.upcase}_CPPFLAGS"] = %x[pkg-config --cflags #{model}].chomp
      ENV["#{model.upcase}_LDFLAGS"] = %x[pkg-config --libs #{model}].chomp
    end

    system "cmake", ".", *std_cmake_args
    system "make", "just_hydrotrend"
    system "cd csdms && ./configure --prefix=#{prefix}"
    system "cd csdms && make"
    system "cd csdms && make install"
  end

  test do
    ENV['SIDL_DLL_PATH'] = "#{HOMEBREW_PREFIX}/share/cca"
    ENV['PYTHONPATH'] = prefix + "lib/#{python_version}/site-packages"
    ENV['LD_RUN_PATH'] = lib
    ENV['LD_LIBRARY_PATH'] = lib
    system "python", "-c", "from csdms.model.Child import Child; Child()"
  end

  def python_version
    "python" + `python -c 'import sys; print(sys.version[:3])'`.strip
  end

  def caveats; <<-EOS.undent
    Set the PYTHONPATH environment variable:
      export SIDL_DLL_PATH=#{HOMEBREW_PREFIX}/share/cca
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{python_version}/site-packages
    EOS
  end
end
