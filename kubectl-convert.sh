# A plugin for Kubernetes command-line tool kubectl, which allows you to convert manifests between different API versions.
# This can be particularly helpful to migrate manifests to a non-deprecated api version with newer Kubernetes release.

#Download the latest release with the command:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert"

#install kubectl-convert
sudo install -o root -g root -m 0755 kubectl-convert /usr/local/bin/kubectl-convert

#Verify plugin is successfully installed
kubectl convert --help