 let
   nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
   pkgs = import nixpkgs { config = {}; overlays = []; };
 in

 pkgs.mkShellNoCC {
   packages = with pkgs; [
     pkgs.talosctl
     pkgs.kubectl
   ];

   KUBECONFIG = "kubeconfig";
   TALOSCONFIG = "talosconfig";

  shellHook = ''
    #echo "Control Node:$CONTROL_PLANE_IP"
  '';
  }