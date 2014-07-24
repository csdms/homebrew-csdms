require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Coupling < Formula
  version "0.1"
  homepage "https://github.com/csdms/coupling"
  url "https://github.com/csdms/coupling", :using => :git
  sha1 ""

  option "without-check", "Skip build-time tests (not recommended)"

  # depends_on "cmake" => :build
  depends_on :python
  depends_on "scipy" => :python
  depends_on "esmpy"
  depends_on "netcdf"
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
    # ENV.deparallelize  # if your formula fails when building in parallel
    #ENV['PYTHONPATH'] = lib + "#{python_version}/site-packages"
    site_packages_suffix = "lib/#{python_version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec + site_packages_suffix
    ENV.prepend_create_path "PYTHONPATH", prefix + site_packages_suffix

    install_args = ["setup.py", "install", "--prefix=#{libexec}"]

    res = %w[nose shapely netcdf pyyaml]
    res.each do |r|
      resource(r).stage do
        system "python", *install_args
      end
    end

    system "#{libexec}/bin/nosetests" if build.with? "check"

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm Dir["#{bin}/nosetests*"]
  end

  test do
    system "python", "-c", "import cmt"
  end

  def python_version
    "python" + `python -c 'import sys; print(sys.version[:3])'`.strip
  end

  def package_installed? python, module_name
    quiet_system python, "-c", "import #{module_name}"
  end

end
