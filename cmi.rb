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

    [
      %w{child child},
      %w{cem deltas},
      %w{plume plume},
      %w{waves waves},
      %w{hydrotrend hydrotrend},
      %w{sedflux2d sedflux2d},
      %w{sedflux3d sedflux3d},
    ].each do |model, pkg|
      ENV["#{model.upcase}_CPPFLAGS"] = %x[pkg-config --cflags #{pkg}].chomp
      ENV["#{model.upcase}_LDFLAGS"] = %x[pkg-config --libs #{pkg}].chomp
    end

    system "cmake", ".", *std_cmake_args
    system "make", "just_hydrotrend"
    system "cd csdms && ./configure --prefix=#{prefix}"
    system "cd csdms && make"
    system "cd csdms && make install"

    inreplace Dir["#{share}/cca/*cca"], /\.la/, ".dylib"
  end

  test do
    ENV['SIDL_DLL_PATH'] = "#{HOMEBREW_PREFIX}/share/cca"
    ENV.prepend_path 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{python_version}/site-packages"
    ENV.prepend_path 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/cca-spec-babel-0_8_6-babel-1.4.0/#{python_version}/site-packages"

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
