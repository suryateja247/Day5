# Jenkins Seed Notes

Create two Jenkins jobs:

1. Platform pipeline
   - Pipeline script from SCM
   - Script path: `jenkins/pipelines/Jenkinsfile.platform`

2. Application multibranch pipeline
   - Pipeline script from SCM
   - Script path: `jenkins/pipelines/Jenkinsfile.app`

Add this repo as a Jenkins shared library:

- Name: `enterprise-devops-platform`
- Default version: main
- Retrieval method: Modern SCM
- Library path: `jenkins/shared-library`

Required Jenkins credentials:

- `artifact-registry-creds`: username/password for JFrog or Nexus.
- `aws-shared-services-role`: optional AWS role credential.
- Per-environment role ARNs can be passed as Jenkins parameters.
