{
    inputs = {
        ihp.url = "github:digitallyinduced/ihp";
        nixpkgs.follows = "ihp/nixpkgs";
        flake-parts.follows = "ihp/flake-parts";
        devenv.follows = "ihp/devenv";
        systems.follows = "ihp/systems";
    };

    outputs = inputs@{ ihp, flake-parts, systems, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {

            systems = import systems;
            imports = [ ihp.flakeModules.default ];

            perSystem = { pkgs, system, ... }: {
                # Allow unfree packages
                _module.args.pkgs = import inputs.nixpkgs {
                    inherit system;
                    config.allowUnfree = true;
                };

                ihp = {
                    enable = true;

                    projectPath = ./.;
                    packages = with pkgs; [
                        # Native dependencies, e.g. imagemagick
                        imagemagick
                        nodejs

                        (nodePackages.tailwindcss.overrideAttrs
                            (_: {
                                plugins = [
                                    nodePackages."@tailwindcss/aspect-ratio"
                                    nodePackages."@tailwindcss/forms"
                                    nodePackages."@tailwindcss/language-server"
                                    nodePackages."@tailwindcss/line-clamp"
                                    nodePackages."@tailwindcss/typography"
                                ];
                            })
                        )
                    ];
                    haskellPackages = p: with p; [
                        # Haskell dependencies go here
                        p.ihp
                        cabal-install
                        base
                        wai
                        text
                        hlint
                        jwt
                        # Markdown
                        mmark
                        # Elasticsearch
                        bloodhound
                        hspec
                    ];
                };

                devenv.shells.default = {
                    # Custom processes that don't appear in https://devenv.sh/reference/options/
                    processes = {
                        tailwind.exec = "tailwindcss -c tailwind/tailwind.config.js -i ./tailwind/app.css -o static/app.css --watch=always";
                    };

                    # Enable Elasticsearch service
                    services.elasticsearch = {
                        enable = true;
                        package = pkgs.elasticsearch7;
                    };

                    # This is needed so when running tests in GitHub actions, we can execute `devenv up &` without an error.
                    # Conditionally set process.implementation based on the presence of GITHUB_ACTIONS
                    process = pkgs.lib.mkIf (builtins.getEnv "GITHUB_ACTIONS" != "") {
                        implementation = "overmind";
                    };
                };
            };
        };
}