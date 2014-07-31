require "formula"

class Cmi < Formula
  version "0.1"
  homepage "http://csdms.colorado.edu"
  url "https://github.com/csdms/cmi", :using => :git
  sha1 ""

  depends_on :python
  depends_on "babel"
  depends_on "cca-spec-babel"
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

    [ %w{child child},
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

    ENV.prepend_path 'PYTHONPATH', Formula['boccatools'].lib + "#{python_version}/site-packages"

    system "cmake", ".", *std_cmake_args
    system "make", "just_hydrotrend"
    system "cd csdms && ./configure --prefix=#{prefix}"
    system "cd csdms && make"
    system "cd csdms && make install"

    inreplace Dir["#{share}/cca/*cca"], /\.la/, ".dylib"

    (bin + 'cmi-env').write env_script
  end

  test do
    %w[Child Hydrotrend Sedflux2d Sedflux3d].each do |component|
      system "eval $(#{bin}/cmi-env) && python -c 'from csdms.model.#{component} import #{component}; #{component}()'"
    end
  end

  def python_version
    "python" + `python -c 'import sys; print(sys.version[:3])'`.strip
  end

  def caveats; <<-EOS.undent
    To set up your environment:
        eval $(cmi-env)
    EOS
  end

  def env_script
    cca_spec_lib = %x[cca-spec-babel-config --var CCASPEC_BABEL_LIBS].chomp
    babel_lib = Formula['babel'].lib
    site_packages = "#{python_version}/site-packages"

    ENV['SIDL_DLL_PATH'] = "#{share}/cca"
    ENV['PYTHONPATH'] = [
      "#{lib}/#{site_packages}",
      "#{cca_spec_lib}/#{site_packages}",
      "#{babel_lib}/#{site_packages}"
    ].join(':')
    ENV['LD_LIBRARY_PATH'] = ENV['LD_RUN_PATH'] = lib

    vars = %w[SIDL_DLL_PATH PYTHONPATH LD_RUN_PATH LD_LIBRARY_PATH]

    contents = "#!/usr/bin/env bash\n"
    vars.each do |var|
      contents << "echo export #{var}='#{ENV[var]}';\n"
    end

    return contents
  end
end