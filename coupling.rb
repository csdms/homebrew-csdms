require "formula"

class Coupling < Formula
  version "0.1"
  homepage "https://github.com/csdms/coupling"
  url "https://github.com/csdms/coupling", :using => :git
  sha1 ""

  option "without-check", "Skip build-time tests (not recommended)"
  option "with-python=", "Path to a python binary"

  depends_on :python unless OS.linux?
  depends_on "scipy" => :python unless OS.linux?
  depends_on "csdms/tools/esmpy"
  depends_on "homebrew/science/netcdf" unless OS.linux?
  depends_on "csdms/dupes/netcdf" if OS.linux?
  depends_on "geos"

  resource 'nose' do
    url 'https://pypi.python.org/packages/source/n/nose/nose-1.3.3.tar.gz'
    sha1 'cad94d4c58ce82d35355497a1c869922a603a9a5'
  end

  resource 'shapely' do
    url 'https://pypi.python.org/packages/source/S/Shapely/Shapely-1.3.3.tar.gz'
    sha1 '1d483201b7be0ebabce2d2b6e9f41ddaff7b4181'
  end

  resource 'netcdf' do
    url 'https://pypi.python.org/packages/source/n/netCDF4/netCDF4-1.1.0.tar.gz'
    sha1 '551f64f3f815a3cb0efd4e53d902ea77e763cccf'
  end

  resource 'pyyaml' do
    url 'https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz'
    sha1 '1a2d5df8b31124573efb9598ec6d54767f3c4cd4'
  end

  def install
    ENV.prepend_path 'PATH', File.dirname(which_python)

    site_packages_suffix = "lib/#{python_version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec + site_packages_suffix
    ENV.prepend_create_path "PYTHONPATH", prefix + site_packages_suffix

    install_args = ["setup.py", "install", "--prefix=#{libexec}"]

    resource('nose').stage do
      system which_python, *install_args
    end unless package_installed? which_python, "nose"

    resource('shapely').stage do
      system which_python, *install_args
    end unless package_installed? which_python, "shapely"

    resource('pyyaml').stage do
      system which_python, *install_args
    end unless package_installed? which_python, "yaml"

    resource('netcdf').stage do
      ENV["NETCDF4_DIR"] = Formula["netcdf"].prefix
      ENV["HDF5_DIR"] = Formula["hdf5"].prefix
      system which_python, *install_args
    end unless package_installed? which_python, "netCDF4"

    system which_python, "setup.py", "install", "--prefix=#{prefix}"

    ENV.prepend_path "PYTHONPATH", Formula["esmpy"].prefix + site_packages_suffix
    ENV.prepend_path 'PATH', "#{libexec}/bin"
    system which_nosetests if build.with? "check"

    rm Dir["#{bin}/nosetests*"]
  end

  test do
    system "python", "-c", "import cmt"
  end

  def which_python
    python = ARGV.value('with-python') || which('python').to_s
    raise "#{python} not found" unless File.exist? python
    return python
  end

  def which_nosetests
    nosetests = which('nosetests') || python_prefix + '/bin/nosetests'
    raise "#{nosetests} not found" unless File.exist? nosetests
    return nosetests
  end

  def python_prefix
    `#{which_python} -c 'import sys; print(sys.prefix)'`.strip
  end

  def python_version
    "python" + `python -c 'import sys; print(sys.version[:3])'`.strip
  end

  def package_installed? python, module_name
    quiet_system python, "-c", "import #{module_name}"
  end

end
