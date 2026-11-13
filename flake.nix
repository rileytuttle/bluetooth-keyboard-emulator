{
  description = "Bluetooth HID-device keyboard emulator (type on your phone from your PC)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # NixOS host:
      #   imports = [ inputs.bluetooth-keyboard-emulator.nixosModules.default ];
      # See README.md for the full writeup and the home-manager alternative.
      nixosModules.default = import ./module.nix;

      # home-manager on a non-NixOS host:
      #   imports = [ inputs.bluetooth-keyboard-emulator.homeManagerModules.default ];
      # then run `bt-kb-setup` once. Only installs the user-facing half --
      # see home.nix and README.md.
      homeManagerModules.default = import ./home.nix;

      # `nix run github:rileytuttle/bluetooth-keyboard-emulator`, or `nix
      # build` here directly. module.nix/home.nix build their own copy via
      # callPackage against the host's own pkgs, so this output is just for
      # standalone use.
      packages.${system}.default = pkgs.callPackage ./package.nix { };

      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system}.package = self.packages.${system}.default;
    };
}
