{
  description = "Application layer for pythoneda-artifact/pyproject-versioning";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-base = {
      url = "github:pythoneda/base/0.0.1a16";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-artifact-event-versioning = {
      url = "github:pythoneda-artifact-event/versioning/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-artifact-event-infrastructure-versioning = {
      url = "github:pythoneda-artifact-event-infrastructure/versioning/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-event-versioning.follows =
        "pythoneda-artifact-event-versioning";
    };
    pythoneda-artifact-pyproject-versioning = {
      url = "github:pythoneda-artifact/pyproject-versioning/0.0.1a2";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-event-versioning.follows =
        "pythoneda-artifact-event-versioning";
    };
    pythoneda-infrastructure-base = {
      url = "github:pythoneda-infrastructure/base/0.0.1a12";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-artifact-infrastructure-pyproject-versioning = {
      url =
        "github:pythoneda-artifact-infrastructure/pyproject-versioning/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-pyproject-versioning.follows =
        "pythoneda-artifact-pyproject-versioning";
      inputs.pythoneda-infrastructure-base.follows =
        "pythoneda-infrastructure-base";
      inputs.pythoneda-artifact-event-versioning.follows =
        "pythoneda-artifact-event-versioning";
      inputs.pythoneda-artifact-event-infrastructure-versioning.follows =
        "pythoneda-artifact-event-infrastructure-versioning";
      inputs.pythoneda-shared-git.follows = "pythoneda-shared-git";
    };
    pythoneda-application-base = {
      url = "github:pythoneda-application/base/0.0.1a12";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-infrastructure-base.follows =
        "pythoneda-infrastructure-base";
    };
    pythoneda-shared-git = {
      url = "github:pythoneda-shared/git/0.0.1a4";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        pname = "pythoneda-artifact-application-pyproject-versioning";
        description =
          "Application layer for pythoneda-artifact/pyproject-versioning";
        license = pkgs.lib.licenses.gpl3;
        homepage =
          "https://github.com/pythoneda-artifact-application/pyproject-versioning";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/shared.nix;
        pythonpackage = "pythonedaartifactapplicationpyprojectversioning";
        entrypoint = "${pythonpackage}/${pname}.py";
        pythoneda-artifact-application-pyproject-versioning-for = { pname
          , version, pythoneda-base, pythoneda-artifact-event-versioning
          , pythoneda-artifact-event-infrastructure-versioning
          , pythoneda-artifact-pyproject-versioning
          , pythoneda-infrastructure-base
          , pythoneda-artifact-infrastructure-pyproject-versioning
          , pythoneda-application-base, pythoneda-shared-git, python }:
          let
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            src = ./.;
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              dbus-next
              GitPython
              grpcio
              pythoneda-application-base
              pythoneda-artifact-event-versioning
              pythoneda-artifact-event-infrastructure-versioning
              pythoneda-artifact-pyproject-versioning
              pythoneda-artifact-infrastructure-pyproject-versioning
              pythoneda-base
              pythoneda-infrastructure-base
              pythoneda-shared-git
              requests
            ];

            checkInputs = with python.pkgs; [ pytest ];

            pythonImportsCheck = [ pythonpackage ];

            preBuild = ''
              python -m venv .env
              source .env/bin/activate
              pip install ${pythoneda-application-base}/dist/pythoneda_application_base-${pythoneda-application-base.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-versioning}/dist/pythoneda_artifact_event_versioning-${pythoneda-artifact-event-versioning.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-infrastructure-versioning}/dist/pythoneda_artifact_event_infrastructure_versioning-${pythoneda-artifact-event-infrastructure-versioning.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-pyproject-versioning}/dist/pythoneda_artifact_pyproject_versioning-${pythoneda-artifact-pyproject-versioning.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-infrastructure-pyproject-versioning}/dist/pythoneda_artifact_infrastructure_pyproject_versioning-${pythoneda-artifact-infrastructure-pyproject-versioning.version}-py3-none-any.whl
              pip install ${pythoneda-base}/dist/pythoneda_base-${pythoneda-base.version}-py3-none-any.whl
              pip install ${pythoneda-infrastructure-base}/dist/pythoneda_infrastructure_base-${pythoneda-infrastructure-base.version}-py3-none-any.whl
              pip install ${pythoneda-shared-git}/dist/pythoneda_shared_git-${pythoneda-shared-git.version}-py3-none-any.whl
              rm -rf .env
            '';

            postInstall = ''
              mkdir $out/dist $out/bin
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
              chmod +x $out/lib/python${pythonMajorMinorVersion}/site-packages/${entrypoint}
              echo '#!/usr/bin/env sh' > $out/bin/${pname}.sh
              echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/${pname}.sh
              echo '${python}/bin/python ${entrypoint} $@' >> $out/bin/${pname}.sh
              chmod +x $out/bin/${pname}.sh
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
        pythoneda-artifact-application-pyproject-versioning-0_0_1a2-for =
          { pythoneda-base, pythoneda-artifact-event-versioning
          , pythoneda-artifact-event-infrastructure-versioning
          , pythoneda-artifact-pyproject-versioning
          , pythoneda-infrastructure-base
          , pythoneda-artifact-infrastructure-pyproject-versioning
          , pythoneda-application-base, pythoneda-shared-git, python }:
          pythoneda-artifact-application-pyproject-versioning-for {
            version = "0.0.1a2";
            inherit pname pythoneda-base pythoneda-artifact-event-versioning
              pythoneda-artifact-event-infrastructure-versioning
              pythoneda-artifact-pyproject-versioning
              pythoneda-infrastructure-base
              pythoneda-artifact-infrastructure-pyproject-versioning
              pythoneda-application-base pythoneda-shared-git python;
          };
      in rec {
        packages = rec {
          pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              pythoneda-artifact-event-versioning =
                pythoneda-artifact-event-versioning.packages.${system}.pythoneda-artifact-event-versioning-latest-python39;
              pythoneda-artifact-event-infrastructure-versioning =
                pythoneda-artifact-event-infrastructure-versioning.packages.${system}.pythoneda-artifact-event-infrastructure-versioning-latest-python39;
              pythoneda-artifact-pyproject-versioning =
                pythoneda-artifact-pyproject-versioning.packages.${system}.pythoneda-artifact-pyproject-versioning-latest-python39;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python39;
              pythoneda-artifact-infrastructure-pyproject-versioning =
                pythoneda-artifact-infrastructure-pyproject-versioning.packages.${system}.pythoneda-artifact-infrastructure-pyproject-versioning-latest-python39;
              pythoneda-application-base =
                pythoneda-application-base.packages.${system}.pythoneda-application-base-latest-python39;
              pythoneda-shared-git =
                pythoneda-shared-git.packages.${system}.pythoneda-shared-git-latest-python39;
              python = pkgs.python39;
            };
          pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              pythoneda-artifact-event-versioning =
                pythoneda-artifact-event-versioning.packages.${system}.pythoneda-artifact-event-versioning-latest-python310;
              pythoneda-artifact-event-infrastructure-versioning =
                pythoneda-artifact-event-infrastructure-versioning.packages.${system}.pythoneda-artifact-event-infrastructure-versioning-latest-python310;
              pythoneda-artifact-pyproject-versioning =
                pythoneda-artifact-pyproject-versioning.packages.${system}.pythoneda-artifact-pyproject-versioning-latest-python310;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python310;
              pythoneda-artifact-infrastructure-pyproject-versioning =
                pythoneda-artifact-infrastructure-pyproject-versioning.packages.${system}.pythoneda-artifact-infrastructure-pyproject-versioning-latest-python310;
              pythoneda-application-base =
                pythoneda-application-base.packages.${system}.pythoneda-application-base-latest-python310;
              pythoneda-shared-git =
                pythoneda-shared-git.packages.${system}.pythoneda-shared-git-latest-python310;
              python = pkgs.python310;
            };
          pythoneda-artifact-application-pyproject-versioning-latest-python39 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39;
          pythoneda-artifact-application-pyproject-versioning-latest-python310 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310;
          pythoneda-artifact-application-pyproject-versioning-latest =
            pythoneda-artifact-application-pyproject-versioning-latest-python310;
          default = pythoneda-artifact-application-pyproject-versioning-latest;
        };
        defaultPackage = packages.default;
        apps = rec {
          pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39;
              inherit pname;
            };
          pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310;
              inherit pname;
            };
          pythoneda-artifact-application-pyproject-versioning-latest-python39 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39;
          pythoneda-artifact-application-pyproject-versioning-latest-python310 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310;
          pythoneda-artifact-application-pyproject-versioning-latest =
            pythoneda-artifact-application-pyproject-versioning-latest-python310;
          default = pythoneda-artifact-application-pyproject-versioning-latest;
        };
        defaultApp = apps.default;
        devShells = rec {
          pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              python = pkgs.python39;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              python = pkgs.python310;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-artifact-application-pyproject-versioning-latest-python39 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python39;
          pythoneda-artifact-application-pyproject-versioning-latest-python310 =
            pythoneda-artifact-application-pyproject-versioning-0_0_1a2-python310;
          pythoneda-artifact-application-pyproject-versioning-latest =
            pythoneda-artifact-application-pyproject-versioning-latest-python310;
          default = pythoneda-artifact-application-pyproject-versioning-latest;

        };
      });
}
