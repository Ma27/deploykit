{ buildPythonPackage
, mypy
, black
, setuptools
, ruff
, glibcLocales
, pytestCheckHook
, openssh
, bash
, lib
, stdenv
}:

buildPythonPackage {
  name = "deploykit";
  src = ./..;

  buildInputs = [
    setuptools
  ];

  checkInputs = [
    mypy
    black
    glibcLocales
    pytestCheckHook
    openssh
    bash
    ruff
  ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_ssh" ];

  # don't swallow stdout/stderr
  pytestFlagsArray = [ "-s" ];

  postCheck = ''
    echo -e "\x1b[32m## run mypy\x1b[0m"
    MYPYPATH=$(pwd):$(pwd)/tests mypy --strict --namespace-packages --explicit-package-bases .
  '';
  meta = with lib; {
    description = "Execute commands remote via ssh and locally in parallel with python";
    homepage = "https://github.com/numtide/deploykit";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
