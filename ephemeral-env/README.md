# Create new ephemeral environment with skaffold

## Prerequisites:

1. Helm 3

2. kubectl versions:

   > Server Version: v1.15.x

   > Client Version: v1.16.3

3. bash version 4.4 or above

4. AWS Profile setup with the name development as below:

```
     [profile development]
     aws_saml_url = value
     role_arn = role_arn
     region = aws_region
     assume_role_ttl = 8h
```

5. Skaffold (https://skaffold.dev/docs/install/). Working skaffold version v1.3.1 .

6. Docker registry credentials. Contact your Administrator to get the credentials, If you don't have them.

   These registry credentials are required for enabling skaffold to:

   1. Push the locally built images to remote registry
   2. Create an image pull secret in ephemeral cluster to pull these images in remote cluster.

7. Setup kubectl with proper kube contexts like ephemeral-development, minikube.

   > kubectl config set-context `<new-context-name>` --cluster `<cluster-name>`

   > kubectl config use-context `<new-context-name>`

8. Install the yq (version > 3.1.0) utility to parse the yaml file. The steps to install are available at below link.

```
https://github.com/mikefarah/yq
```

## Steps to create new environment:

1. Clone the required repos in a directory:

```
     $ git clone git@github.com:OpenGov/Ephemeral.run.git
```

2. Change directory to `ephemeral.run/ephemeral-env/`.
   Create the `env.yaml` file by copying the `env.sample.yaml`. Update all the env file parameters with required values.

```
$ cp env.sample.yaml env.yaml
```

3. Run the script to update the helm dependencies.

```
$ ./Ephemeral.run/ephemeral-env/helm_dep_update.sh
```

6. Run below command depending on where you want to create the environment (minikube, EKS cluster). Make sure you have the valid aws credentials setup with development profile.

```
$ ./init.sh ephemeral-development
  OR
$ ./init.sh minikube
  OR
$ ./init.sh ephemeral-development-delete       # to delete the environment
```

The `init.sh` script will generate a `skaffold.yaml` file from `skaffold.template.yaml` in the same directory by replacing the values from `env.yaml` file.
It uses `parse_yaml.sh` script for parsing the `skaffold.template.yaml` file & replacing the values in it.
Then it starts the deployment with the skaffold run command. e.g. `skaffold run -p ephemeral-development -f skaffold.yaml`

7. After successful run the init script will output the domain name assigned to the environment, which can be used to access the environment.

## Domain name assignment for ephemeral environments:

1. `domain_names.txt` file contains the list of predefined domain names which will be used. If you are using SSL, there should be certificates defined for each of these domain names.
2. `init.sh` imports/sources the `get_domain` function from `get_domain.sh` file.
3. The variables required in the `get_domain` function are set via env substitution step in `init.sh`.
4. `get_domain` function works as below:
   1. It first checks whether the environment already has a domain name assigned to it by querying the nginx service in the concerned namespace.
   2. If domain name is assigned, it uses the same domain name, else assigns a new one.
   3. To find new unused domain name, it populates the values in 2 arrays:
      - `ALL_DOMAINS` which take values from `domain_names.txt`.
      - `USED_DOMAINS` which contains domains currently in use, queried from route53.
   4. After comparing these two lists, it creates a new array `UNUSED_DOMAINS` then randomly selects one of the domain names from this array.

## Manage environments:

1. `manage_env.sh` script can be used to:
   - check currently existing environments & some details about them.
   - delete the environment
2. run `./manage_env.sh` to see the environment list with basic details.
3. run `./manage_env.sh delete-namespace` to delete any environment.
