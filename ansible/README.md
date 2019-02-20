# Playbooks to manage Kubernetes cluster configuration

Here you will find some playbooks to configure your kubernetes cluster in multiple ways

# Playbooks

## user_account.yml

Used to create or delete service accounts.

TODO: get user facts after creation to retrieve secrets.

### Input variables

* *k8s_user*: new user name.
* *namespace*: namespace where the user will be created/deleted.
* *server_url*: Kubernetes API server URL. This is used to write the new user kubeconfig file.
* *is_admin*: Optional. If set to "true", then the service account will be linked to an admin cluster role.

# Examples

## Create minio user
```
ansible-playbook setup_minio_user.yml -vvvv -e "minio_user=argo minio_server=minio"
```

## Create kubernetes admin user
```
ansible-playbook user_account.yml -vvvv -e "k8s_user=askhari namespace=kube-system server_url=https://your.kubernetes.api is_admin=true"
```

## Create kubernetes user
```
ansible-playbook user_account.yml -vvvv -e "k8s_user=donetus namespace=donetus server_url=https://your.kubernetes.api"
```
