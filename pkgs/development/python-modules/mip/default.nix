{ lib
, fetchFromGitHub
, substituteAll
, buildPythonPackage
, setuptools_scm
, cffi
, numpy
, networkx
, matplotlib
, cbc
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mip";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "python-mip";
    rev = version;
    sha256 = "1w3y2wwb93f250l9d173bah823brrfkvd9rw364rqisk3v379i5w";
  };

  # patches = [
  #   # Hardcode path to CBC rather than using the pre-compiled .so files
  #   # that this project includes on github for various architectures
  #   (substituteAll {
  #     src = ./0001-Patch-so-that-on-nix-we-can-load-Cbc-from-nixpkgs.patch;
  #     cbc_library = "${cbc}/lib/libCbcSolver.so";
  #   })
  # ];
  # rm -r mip/libraries/*

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ cffi numpy networkx ];
  checkInputs = [ pytestCheckHook matplotlib ];
  pytestFlagsArray = ["-vvv"];

  pythonImportsCheck = [ "mip" ];

  meta = with lib; {
    homepage = "https://python-mip.com/";
    description = "Python tools for Modeling and Solving Mixed-Integer Linear Programs (MIPs)";
    maintainers = with maintainers; [ rmcgibbo ];
    license = licenses.epl20;
  };
}
