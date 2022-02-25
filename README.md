# Interoperability Platform Deployment
Deployment of all services required to run the Interoperability platform.

Main features:
- deployment of the whole platform with a single pipeline
- reproducible deployments of the entire platform, by specifying a version for each module
- coexistence of different versions of the platform, by deploying each platform in an independent kubernetes namespace
- automatic creation of the databases schemas required by the modules


## How to use it
The pipeline runs from a branch or a tag (hereafter source) of this project repository.\
The source name is expected to be in the `GIT_LOCAL_BRANCH` environment variable.\
All services are deployed in a kubernetes namespace named as the source (with minor replacement to follow kubernetes naming requirements).

### Hostname
The pipeline leverages on different hostnames, based on required visibility:
- `internal` Reachable only by services in the cluster or users within a VPN
- `external` Reachable by everyone (public access on the internet)

The definition of `internal` and `external` hostnames can be found in each environment configuration file.\
Each service can be defined to use the `internal` or the `external` hostname.
> Note: Development environment forces all hostnames to `internal`

Services in each namespace can be reached at the hostname
```
https://<namespace>.<internal/external>
```


#### Database
Each service may request to configure Postgres database schemas by including in its `kustomization.yaml` file the row
```
- ../../commons/database/db.yaml
```
and in its `configmap.yaml` file the value
```
  POSTGRES_SCHEMA: "{{NAMESPACE}}_<schemaName>"
```
where `<schemaName>` is defined by each service.\
These configurations will create a schema with the tables required to the backend services defined with the [PDND template](https://github.com/pagopa/pdnd-uservice-rest-template).\
The resulting schema will be named as
`<namespace>_<schemaName>`

## Interop Modules
Modules specific to Interoperability Platform

### Backends
Backends modules are based on the [template](https://github.com/pagopa/pdnd-uservice-rest-template).\
The deployment leverages on `kustomize`.

### Frontend
The frontend is currently deployed as a docker image which contains the `nginx` with ui static files.\
A file is injected in order to configure the hostname at deployment time and not at build time.

## SPID Modules
SPID modules should be deployed only in dev and test environments.

### Service Provider
[hub-spid-login-ms](https://github.com/pagopa/hub-spid-login-ms) is the Service Provider that manages the login with SPID.\
The service url is `https://<namespace>.<externalHostName>/hub-spid-login-ms`\
This service must be reachable from the Frontend client.

### Identity Provider
[spid-testenv2](https://github.com/italia/spid-testenv2) Identity Provider mock.\
The service url is `https://<namespace>-idp.<externalHostName>`\
This service must be reachable from the Frontend client.

### Redis
Required by the login module.\
This service is not reachable outside the namespace.


## Open Points
Resources created must be deleted manually.\
Resources:
- namespaces
- DNS entries
- databases

Deletions could be performed automatically if we intercept branch deletion (e.g. GitHub hooks)