# Python CI/CD Demo — GitHub Actions and Docker

A small Python HTTP health-check service demonstrating automated testing, container image creation, and a GitHub Actions delivery workflow.

## What this project demonstrates

- Git-based source control.
- Python unit tests using the standard-library unittest framework.
- Automated test execution with GitHub Actions.
- Docker image creation.
- Workflow configuration for publishing to GitHub Container Registry (GHCR).
- A non-root user inside the Docker container.
- Separation of validation (CI) from image publishing (CD).

## Workflow location and behaviour

The workflow is stored at the repository root in [.github/workflows/python-cicd.yml](../../.github/workflows/python-cicd.yml). GitHub Actions discovers repository workflows from this root-level directory; the application itself remains in this project folder.

1. A push to main or a pull request targeting main runs the workflow when files in this project or the workflow definition change.
2. GitHub Actions checks out the repository and runs the Python unit tests from this directory.
3. If tests pass, the workflow builds the Docker image using this project's directory as the build context.
4. Pull requests build the image but do not publish it.
5. A push to main publishes two image tags to GHCR: latest and sha-<commit-sha>.

The workflow uses the automatically provided GITHUB_TOKEN; no personal access token is required. It declares packages: write permission for publishing.

## Run locally

Requires Python 3.12 or a compatible version. From this project directory, run:

    python -m unittest discover -s tests -v
    python app.py

In another terminal, test the health endpoint:

    curl http://localhost:8080/health

Expected response:

    {"status": "healthy", "service": "python-cicd-demo"}

## Build and run with Docker

From this project directory:

    docker build -t python-cicd-demo .
    docker run --rm -p 8080:8080 python-cicd-demo

Then visit http://localhost:8080/health or run the curl command above.

## Verify the GitHub Actions workflow

1. Open the repository on GitHub.
2. Select the Actions tab.
3. Open the Python CI/CD workflow run.
4. Confirm that Run Python tests succeeds.
5. Confirm that Build Docker image succeeds.
6. After a successful push to main, check the repository owner's Packages page for python-cicd-demo.

A workflow definition in the repository does not by itself prove that a run has passed. Record a successful run and its result before describing the pipeline as verified. If the package is private, configure its visibility in GitHub's package settings before sharing it publicly.

## Suggested failure experiment

Make a deliberate temporary change in tests/test_app.py, such as expecting the status to be unhealthy. Commit and push the change on a test branch. Observe the test job fail and the dependent image build/publish job be skipped. Revert the temporary change afterwards.

## CV wording — only after successful verification

**Python CI/CD Pipeline — GitHub Actions and Docker**

- Configured a GitHub Actions workflow to run Python unit tests on relevant pushes and pull requests.
- Configured Docker image builds and GHCR publishing after successful tests on pushes to the main branch.
- Packaged the application in a Docker container configured to run as a non-root user.

Only use these bullets after you have successfully run and verified the workflow. Describe this as a portfolio project, not production deployment experience.
