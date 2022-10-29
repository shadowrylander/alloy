{
    nixConfig = {
        # Adapted From: https://github.com/divnix/digga/blob/main/examples/devos/flake.nix#L4
        # extra-substituters = "https://cache.nixos.org/ https://nix-community.cachix.org/";
        trusted-substituters = "https://cache.nixos.org/";
        # extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        # keep-derivations = true;
        # keep-outputs = true;
        extra-experimental-features = "nix-command flakes";
        # accept-flake-config = true;
        # show-trace = true;
        # fallback = true;
        # auto-optimise-store = true;
        # builders-use-substitutes = true;
        # cores = 0;
        # flake-registry = https://raw.githubusercontent.com/sylvorg/settings/main/flake-registry.json;
        # allow-unsafe-native-code-during-evaluation = true;
        # min-free = 262144000;
        # max-free = 1073741824;
    };
    description = "alloy.el provides a more convenient method for binding keys in emacs (for both evil and non-evil users).";
    inputs = rec {
        settings.url = github:sylvorg/settings;
        titan.follows = "settings/titan";
        nixpkgs.follows = "settings/nixpkgs";
        flake-utils.url = github:numtide/flake-utils;
        flake-compat = {
            url = "github:edolstra/flake-compat";
            flake = false;
        };
    };
    outputs = inputs@{ self, flake-utils, settings, ... }: with builtins; with settings.lib; with flake-utils.lib; settings.mkOutputs {
        inherit inputs;
        type = "emacs-nox";
        pname = "alloy";
        callPackage = { emacs, pname }: emacs.pkgs.trivialBuild rec {
            inherit pname;
            src = ./.;
            buildInputs = flatten [ emacs propagatedUserEnvPkgs ];
            propagatedUserEnvPkgs = with emacs.pkgs; flatten [ naked ];
            meta = {
              inherit (emacs.meta) platforms;
              homepage = "https://github.com/syvlorg/${pname}";
              description = "alloy.el provides a more convenient method for binding keys in emacs (for both evil and non-evil users).";
              long-description = ''
                This package provides convenient wrappers for more succinctly defining
                keybindings. It allows defining multiple keys at once, specifying an
                arbitrary number of named prefix keys to be used in key definitions,
                implicitly wrapping key strings with (naked ...), and more. It provides a
                single function for standard Emacs key definitions as well as aiern key
                definitions for any aiern state and any keymap. It also provides a setup
                function to generate "nmap", "vmap", etc. keybinding functions for aiern.
              '';
            };
        };
    };
}
