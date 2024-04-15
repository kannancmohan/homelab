let
nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
packages = with pkgs; [
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.argocd
];

#KUBECONFIG = "~/.kube/config";

shellHook = ''
alias k="kubectl"
alias kg="kubectl get"
alias tf="terraform"
#helm plugin install https://github.com/databus23/helm-diff
'';
}
