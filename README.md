# rms-skyfall-terraform

## Setup

You need a few things installed first to work correctly

The first thing is the correct version of terraform which is `0.11.10`

```
brew install terraform
pip install awscli
brew install aws-okta
brew install aws-iam-authenticator
```

## Connecting to AWS

In `~/.aws/config` put:

```text
[preview]
cloudfront = true

[profile mgmt]
aws_saml_url = home/amazon_aws/0oa1vrj67vFBy04Cf2p7/272
role_arn = arn:aws:iam::559436771417:role/OktaAdmin
region = us-east-2

[profile dev]
aws_saml_url = home/amazon_aws/0oa1vre5w4pCTOV5Q2p7/272
role_arn = arn:aws:iam::411497945720:role/OktaAdmin
region = us-east-2
```

Run `aws-okta add`:

```text
Okta organization: rms

Okta region ([us], emea, preview): 

Okta domain [us.okta.com]: 

Okta username: <your-sso-username>

Okta password: <your-sso-password> 

INFO[0010] Requesting MFA. Please complete two-factor authentication with your second device 
INFO[0011] Sending Push Notification...                 
INFO[0011] Device: phone1              
```

## Connecting to EKS

If you want to connect to different EKS clusters, you need to run the following

Get a copy of the EKS cluster's config. This will get the management cluster in the us-east-2 region

```
aws-okta exec mgmt -- aws eks update-kubeconfig --name mgmt --region us-east-2 --kubeconfig ~/.kube/mgmt
```

You'll want to enter a bash shell first via `aws-okta`

```
aws-okta exec mgmt -- bash
```


Now to use it, set the `KUBECONFIG` variable to point to that file

```
export KUBECONFIG=~/.kube/mgmt
```

Now you can run kubectl

```
kubectl get ns
```

## Creating a new EKS cluster

1. assuming stack: **mgmt-euw1**, where euw1 is the region: **eu-west-1**, env: **pe**,
2. copy existing stacks/mgmt-ri as new stack `stacks/<stack>-<env>`
3. cd `stacks/<stack>-<env>`, update the following in the main.tf,<br/>
   under **locals** block
   - vpc_id
   - region
   - stack
   - env
   - asg_min_size (optional, default: 2)<br/>
   - asg_desired_capacity (optional, default: 2)<br/>
   - asg_max_size (optional, default: 30)<br/>
   - env_tags (at the least, update stack, env)<br/>
   
   update under **terraform** block
   
   - bucket (optional, ensure that this bucket exists)<br/>
   - key: `"<stack>-<env>-us-east-1/terraform.state"` <br/>
   - region (optional)

4. rename the files<br/>
   - mv mgmt-ri-external-dns.yaml `<stack>-<env>-external-dns.yaml`
   - mv mgmt-ri-kube2iam.yaml `<stack>-<env>-kube2iam.yaml`
   - mv mgmt-ri-nginx-ingress.yaml `<stack>-<env>-nginx-ingress.yaml`

5. open `<stack>-<env>-external-dns.yaml` file, then update<br/>
   - aws.region
   - zoneIdFilters (get the zone from the Route 53 service, also update the comment on line 10)
   - podAnnotations.iam.amazonaws.com/role: `k8s-external-dns-<stack>-<env>`
   - txtOwnerId: `external-dns-<stack>-<env>`
   save it

6. open `<stack>-<env>-nginx-ingress.yaml` file, then update<br/>
   - controller.ingressClass: `<stack>-<env>-nginx` (very important)<br/>
   - controller.service.Annotations.service.beta.kubernetes.io/aws-load-balancer-ssl-cert: get the value from AWS certificate manager service, find the domain you're working on get the arn for the domain.<br/>
   save it

7. open `helm.sh` file, then update the <br/>
   - line 12 (for kube2iam), --name `<stack>-<env>-kube2iam>`, -f `<stack>-<env>-kube2iam.yaml`<br>
   - line 13 (for external-dns), --name `<stack>-<env>-external-dns`, -f `<stack>-<env>-external-dns.yaml`<br>
   - line 14 (for nginx-ingress), --name `<stack>-<env>-nginx-ingress`, -f `<stack>-<env>-nginx-ingress.yaml`<br>
   save it

8. need to create a ssh key, open a terminal, then type<br/>
   `ssh-keygen -t rsa`<br/>
   Enter file in which to save the key (/Users/<username>/.ssh/id_rsa): `/Users/<username>/.ssh/<stack>.<env>`<br/>
   copy the public key `/Users/<username>/.ssh/<stack>.<env>.pub` to ./modules/aws_eks/keys dir<br/>

9. checkin the new stack and make a pr
