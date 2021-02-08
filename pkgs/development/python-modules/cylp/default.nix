{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, pkg-config
, cbc
, cython
, zlib
, bzip2
, cffi
, numpy
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "CyLP";
  version = "0.91.0";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "cylp";
    rev = "v${version}";
    sha256 = "1mdxaxqc2zl6jpyzw4x2awhrwyds3wk0bs96h1d9yckispshvy6s";
  };

  patches = [
    # This patch, currently part of an open PR, https://github.com/coin-or/CyLP/pull/115,
    # fixes compatibility with Python 3.8 and Python 3.9 by removing use of a once-deprecated
    # and now-removed function (`time.clock`).
    (fetchpatch {
      url = "https://github.com/coin-or/CyLP/commit/fdbd32be5637ae05a4f2c9c8173cbccffd309749.patch";
      sha256 = "1vv7kxlwnd77msp13l6z5xxhmr4zk08dhf5jfjyqkr3gr8kxbapi";
    })
  ];
    
  dontStrip = true;
  nativeBuildInputs = [ pkg-config cython ];
  buildInputs = [ cbc zlib bzip2 ];
  propagatedBuildInputs = [ numpy scipy ];

  preBuild = ''
    export CYLP_USE_CYTHON="1"
  '';

  doCheck = false;

  preCheck = ''
    mv cylp/tests .
    rm -rf cylp    
  '';
  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cylp.cy" ];

  meta = with lib; {
    homepage = "https://github.com/coin-or/CyLP";
    description = " A Python interface to CLP, CBC, and CGL to solve LPs and MIPs. ";
    maintainers = with maintainers; [ rmcgibbo ];
    license = licenses.epl10;
  };
}
