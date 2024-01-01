sudo hostnamectl set-hostname kube-w1
sudo kubeadm join [your-master-ip]:6443 --token [token] --discovery-token-ca-cert-hash sha256:[hash]