let
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
    pkgs = import nixpkgs { config = {}; overlays = []; };
    isMacOS = pkgs.stdenv.hostPlatform.system == "darwin";
    useRemoteDocker = "true";
    pythonEnv = pkgs.python3.withPackages (ps: with ps; [
        pip
        molecule
        docker
        ansible
        pytest
        pytest-testinfra
        # Add any additional Python packages you need
    ]);
in

pkgs.mkShellNoCC {
    packages = with pkgs; [
        pythonEnv
        pkgs.docker
        pkgs.kubectl
        pkgs.kubernetes-helm
        pkgs.k9s
        pkgs.copier
        ## added for ansible test
        #pkgs.ansible-lint
        #pkgs.yamllint
        pkgs.parallel
        ## added for go test(terratest)
        pkgs.go
        pkgs.clang
        pkgs.kind
        ## added for ssh access
        pkgs.git
        pkgs.curl
        #pkgs.argocd
        #pkgs.vaultwarden
        #pkgs.prometheus-alertmanager
        #pkgs.postgresql_jit
    ] ++ (if pkgs.stdenv.isDarwin then [ pkgs.darwin.iproute2mac pkgs.darwin.apple_sdk.frameworks.CoreFoundation ] else [ pkgs.iproute2 ]);

    HISTCONTROL = "ignoreboth:erasedups";
    #KUBECONFIG = "~/.kube/config";

    shellHook = ''
        # Added for go test(terratest)
        export CGO_ENABLED=1
        export CC=clang
        export CXX=clang++
        export GOARCH=arm64

        alias k="kubectl"
        alias kg="kubectl get"
        alias tf="terraform"
        #helm plugin install https://github.com/databus23/helm-diff

        if [ "${useRemoteDocker}" = "true" ]; then
            echo "Using remote Docker and setting ssh for the same"
            export DOCKER_HOST=ssh://ubuntu@192.168.0.30
            export REMOTE_DOCKER_IP=192.168.0.30
            ## Start SSH agent if not already running
            if [ -z "$SSH_AGENT_PID" ]; then
                eval $(ssh-agent -s)
                echo "SSH agent started with PID $SSH_AGENT_PID"
            fi
            ## Add host ssh keys
            if $isMacOS; then
                ssh-add --apple-use-keychain ~/.ssh/id_ed25519
            else
                ssh-add ~/.ssh/id_ed25519
            fi
            ## Export the SSH_AUTH_SOCK so that it's available in the shell
            #export SSH_AUTH_SOCK=$SSH_AUTH_SOCK
        else
            echo "Using local Docker"
            # TODO
        fi
        # Ensure Docker is running
        if ! docker info > /dev/null 2>&1; then
            echo "Docker is not running. Please check the Docker daemon."
        fi
    '';
}
