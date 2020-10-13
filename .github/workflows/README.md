---

<h1 id="github-action-workflows">Github Action Workflows</h1>
<h2 id="ephemeral-stack-creation">Ephemeral Stack Creation</h2>
<p>Ephemeral Stack creation is achieved using github actions. Once the new code from the developers is pushed to a repository, pull request is created.<br>
Once the build has been created and images pushed to dockerhub, attach <em><strong>ephemeral-deploy</strong></em> label to the PR. This event will trigger the workflow of stack creation from the target repository.<br>
Create workflow will trigger the actual environment creation using skaffold workflow in the <em><strong>ephemeral.run</strong></em> repository.<br>
The new environment which is created takes the name <em><strong>pr-{REPO_name}-{PR-number}</strong></em><br>
To-redeploy the entire stack just remove the <em><strong>ephemeral-deploy</strong></em> label and attach the same label again. Same stack will be deployed again</p>
<h2 id="ephemeral-stack-deletion">Ephemeral Stack Deletion</h2>
<p>Once the testing of the environment with the new code is done, attach label <em><strong>ephemeral-delete</strong></em>. This event will trigger delete workflow, which will delete the namespace created for the developer.</p>
