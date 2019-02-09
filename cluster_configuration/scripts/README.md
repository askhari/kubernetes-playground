# Helm and Kubernetes configuration scripts

If we use Helm, usually we don't want anyone to use it.
In order to secure a little bit Helm and our Kubernetes cluster we decided to:

1. Secure Helm and Tiller using SSL and certificates.
2. Create namespaced service accounts for external users that may interact with the Kubernetes cluster.

# Securing Helm

I followed the very well explained [Helm documentation](https://docs.helm.sh/using_helm/#securing-your-helm-installation), but to automate the process I implemented *generate_tiller_helm_certificates.sh*.
This script doest the following:

1. Create a private CA.
2. Create Keys and Certificate Requests (CSR) for tiller and helm.
3. Sign the certificates.
4. Show what if would do to configure helm and tiller.
5. Tell you which commands you should execute to finish the installation in case you want to apply the changes.

It's a very simple script, but it eases the task.

# Creating jailed service accounts

By jailed I mean _namespaced_. This means that new users created this way only have permissions for their namespace.
To do show you may use the *create-jailed-user-using-rbac.sh* script.

This script receives only one parameter with the username and then creates:

1. A namespace for that user.
2. A service account for that user.
3. A role binding allowing the user to do whatever it wants in its namespace.
4. a kubeconfig file named <username>-config for that user.

Once it finishes you may give that new <username>-config to the user and it will be able to query the kubernetes API only for its namespace.
