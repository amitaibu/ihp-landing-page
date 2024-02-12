{
    inputs = {
        ihp.url = "github:digitallyinduced/ihp/deploy-to-nixos-fixes";
        nixpkgs.follows = "ihp/nixpkgs";
        flake-parts.follows = "ihp/flake-parts";
        devenv.follows = "ihp/devenv";
        systems.follows = "ihp/systems";
    };

    outputs = inputs@{ self, nixpkgs, ihp, flake-parts, systems, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {

            systems = import systems;
            imports = [ ihp.flakeModules.default ];

            perSystem = { pkgs, ... }: {
                ihp = {
                    enable = true;
                    projectPath = ./.;
                    packages = with pkgs; [
                        # Native dependencies, e.g. imagemagick
                        imagemagick
                        nodejs
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
                    ];
                };
            };

            # Adding the new NixOS configuration for "ihp-app"
            flake.nixosConfigurations."ihp-app" = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = inputs;
                modules = [
                    "${nixpkgs}/nixos/modules/virtualisation/amazon-image.nix"
                    ihp.nixosModules.appWithPostgres
                    ({ lib, pkgs, ... }: {

                        networking.firewall = {
                           enable = true;
                           allowedTCPPorts = [ 22 80 443 8000 ];
                        };

                        security.acme.defaults.email = "no-reply@tpp-qa.gizra.site";
                        security.acme.acceptTerms = true;

                        services.ihp = {
                            domain = "tpp-qa.gizra.site";
                            migrations = ./Application/Migration;
                            schema = ./Application/Schema.sql;
                            fixtures = ./Application/Fixtures.sql;
                            sessionSecret = "M$cmzMCEx7xfL-5_q6%9cpve_0BAd5BbDaOtzhv7";
                            additionalEnvVars = {
                                JWT_PRIVATE_KEY_PATH = "/root/jwtRS256.key";
                                JWT_PUBLIC_KEY_PATH = "/root/jwtRS256.key.pub";
                            };
                        };

                        swapDevices = [ { device = "/swapfile"; size = 2000; } ];

                        system.stateVersion = "23.05";

                        systemd.services.app.preStart = ''
                            if [ ! -f /root/jwtRS256.key ]; then
                                # Generate the private key
                                ${pkgs.openssl}/bin/openssl genpkey -algorithm RSA -out /root/jwtRS256.key -pkeyopt rsa_keygen_bits:4096
                                # Extract the public key from the private key
                                ${pkgs.openssl}/bin/openssl rsa -pubout -in /root/jwtRS256.key -out /root/jwtRS256.key.pub
                            fi
                        '';
                    })
                ];
            };


        };
}
