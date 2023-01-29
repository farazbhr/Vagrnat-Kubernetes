#install the container
curl -sSL https://get.blockbridge.com/container | sh


#install the plugin
docker plugin install --alias block blockbridge/volume-plugin
  BLOCKBRIDGE_API_HOST="YOUR HOST" BLOCKBRIDGE_API_KEY="YOUR KEY"


#KUBERNETES CSI STORAGE GUIDE
#https://kb.blockbridge.com/guide/kubernetes/#blockbridge-configuration

#Set BLOCKBRIDGE_API_HOST to point to your Blockbridge API endpoint.
export BLOCKBRIDGE_API_HOST=192.168.1.203

#Use the containerized CLI to create the account.
docker run --rm -it -e BLOCKBRIDGE_API_HOST docker.io/blockbridge/cli:latest-alpine bb --no-ssl-verify-peer account create --name kubernetes


curl -I -v https://192.168.1.203/api
#Use the containerized CLI to create the auth token
export BLOCKBRIDGE_API_HOST=192.168.1.203
export BLOCKBRIDGE_API_SU=kubernetes
docker run --rm -it -e BLOCKBRIDGE_API_HOST -e BLOCKBRIDGE_API_SU docker.io/blockbridge/cli:latest-alpine bb --no-ssl-verify-peer authorization create --notes 'csi-blockbridge driver access'


access token          1/9Q1l/vCSJkI611Aisycx4CfM/NvO5mOgdaOq7BsxHsa1DWX+8JInAw
#Set the BLOCKBRIDGE_API_KEY environment variable to the new token
export BLOCKBRIDGE_API_KEY="1/9Q1l/vCSJkI611Aisycx4CfM/NvO5mOgdaOq7BsxHsa1DWX+8JInAw"

########################Kubernetes Configuration####################
#Create a file with the definition of a secret for the Blockbridge API.
cat > secret.yml <<- EOF
apiVersion: v1
kind: Secret
metadata:
  name: blockbridge
  namespace: kube-system
stringData:
  api-url: "https://${BLOCKBRIDGE_API_HOST}/api"
  access-token: "$BLOCKBRIDGE_API_KEY"
  ssl-verify-peer: "false"
EOF

#Create the secret in Kubernetes
kubectl create -f ./secret.yml

#Check that the secret exists.
kubectl -n kube-system get secrets blockbridge

#deploy
kubectl apply -f https://get.blockbridge.com/kubernetes/5.1/csi/csi-blockbridge-v2.0.0.yaml

#Check that the driver is running.
kubectl -n kube-system get pods -l role=csi-blockbridge