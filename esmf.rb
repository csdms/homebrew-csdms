require "formula"

class Esmf < Formula
  version "6.3.0"
  homepage "http://www.earthsystemmodeling.org"
  url "http://sourceforge.net/projects/esmf/files/latest/download?source=directory"
  sha1 "4be4689316602e1baeebaf018887e3b8d46c88eb"
  #sha1 "ea60df615387f47bdfdfe4da48f6567c4ec60f74"

  option "with-check", "Run tests before installing"
  option "enable-esmpy", "Build ESMPy"
  option "with-python=", "Path to a python binary" if OS.linux?

  depends_on :fortran
  depends_on "csdms/dupes/netcdf" if OS.linux?
  depends_on "homebrew/science/netcdf" unless OS.linux?

  def install
    ENV.deparallelize

    netcdf = "csdms/dupes/netcdf" if OS.linux?
    netcdf = "homebrew/science/netcdf" unless OS.linux?

    ENV['ESMF_NETCDF'] = "split"
    ENV['ESMF_NETCDF_INCLUDE'] = Formula[netcdf].include
    ENV['ESMF_NETCDF_LIBPATH'] = Formula[netcdf].lib
    ENV['ESMF_NETCDF_LIBS'] = "-lnetcdff -lnetcdf"

    ENV['ESMF_CXX'] = "#{ENV.cxx}"
    ENV['ESMF_F90'] = "#{ENV.fc}"
    ENV['ESMF_COMM'] = "mpiuni"
    ENV['ESMF_DIR'] = buildpath
    ENV['ESMF_INSTALL_PREFIX'] = prefix
    ENV['ESMF_COMPILER'] = esmf_compiler

    system "make"
    system "make check" if build.with? "check"
    system "make", "install"

    if build.include? 'enable-esmpy'
      ENV.prepend_path 'PATH', File.dirname(which_python)

      cd "src/addon/ESMPy" do
        system "python", "setup.py", "build", "--ESMFMKFILE=" + which_esmf_mk,
          "install", "--prefix=#{prefix}"

        system "python", "setup.py", "test_all" if build.with? "check"
      end
    end

  end

  def esmf_compiler
    compiler = File.basename("#{ENV.fc}")
    compiler += File.basename("#{ENV.cc}") if OS.mac?
    return compiler
  end

  def which_python
    python = ARGV.value('with-python') || which('python').to_s
    raise "#{python} not found" unless File.exist? python
    return python
  end

  def which_esmf_mk
    arch = if OS.mac? then "Darwin" else "Linux" end

    path_to_file = lib +
      "libO/#{arch}.#{esmf_compiler}.64.mpiuni.default/esmf.mk"
    raise "#{path_to_file} not found" unless File.exist? path_to_file
    return path_to_file
  end

  test do
    system "false"
  end
end
