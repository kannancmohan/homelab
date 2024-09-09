## Tips
### k3s Cluster tips
#### To Remove a container image
```
# check for the available images . crictl is a command-line interface for CRI-compatible container runtimes. https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/
sudo crictl images
# Note down the container image id and execute the following to remove the image from k3s container engine
sudo crictl rmi <container-image-id>
```