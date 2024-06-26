let
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
    pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
    packages = with pkgs; [
        pkgs.kubectl
        pkgs.kubernetes-helm
        pkgs.k9s
        pkgs.copier
        #pkgs.argocd
        #pkgs.vaultwarden
        #pkgs.prometheus-alertmanager
        #pkgs.postgresql_jit
    ];
    HISTCONTROL = "ignoreboth:erasedups";

    #KUBECONFIG = "~/.kube/config";

    shellHook = ''
    alias k="kubectl"
    alias kg="kubectl get"
    alias tf="terraform"
    #helm plugin install https://github.com/databus23/helm-diff
    '';
}
