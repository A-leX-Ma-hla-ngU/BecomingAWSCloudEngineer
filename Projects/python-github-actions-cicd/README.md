# Python CI/CD Demo — GitHub Actions + Docker

A small portfolio project demonstrating an automated CI/CD workflow for a Python health-check service.

## What this project demonstrates

- Git-based source control.
- Automated Python unit tests with GitHub Actions.
- Docker image creation.
- Automated publishing to GitHub Container Registry (GHCR).
- A non-root user inside the Docker container.
- Separation of validation (CI) from image publishing (CD).

## Pipeline behaviour

1. A push to `main` or a pull request targeting `main` starts the workflow.
2. GitHub Actions checks out the repository and runs the Python unit tests.
3. If tests pass, the workflow builds the Docker image.
4. Pull requests build the image but do not publish it.
5. A push to `main` publishes two image tags to GHCR:
   - `latest`
   - `sha-<commit-sha>`

The workflow uses the automatically provided `GITHUB_TOKEN`; no personal access token is required. The workflow declares `packages: write` permission for publishing.

## Run locally

Requires Python 3.12 or compatible.

```bash
python -m unittest discover -s tests -v
python app.py
```

In another terminal, test the health endpoint:

```bash
curl http://localhost:8080/health
```

Expected response:

```json
{"status": "healthy", "service": "python-cicd-demo"}
```

## Build and run with Docker

```bash
docker build -t python-cicd-demo .
docker run --rm -p 8080:8080 python-cicd-demo
```

Then visit `http://localhost:8080/health` or run the `curl` command above.

## Add this project to GitHub

Create a new, empty GitHub repository named `python-github-actions-cicd`. From this project directory:

```bash
git init
git add .
git commit -m "Build Python CI/CD demo with GitHub Actions and Docker"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/python-github-actions-cicd.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username. The workflow should start automatically after the push.

## Verify the workflow

1. Open the repository on GitHub.
2. Select the **Actions** tab.
3. Open the **Python CI/CD** workflow run.
4. Confirm that **Run Python tests** succeeds.
5. Confirm that **Build Docker image** succeeds.
6. After a successful push to `main`, check the repository owner's **Packages** page for `python-cicd-demo`.

If the package is private, configure its visibility in GitHub's package settings before sharing it publicly.

## Suggested failure experiment

Make a deliberate temporary change in `tests/test_app.py`, such as expecting the status to be `unhealthy`. Commit and push the change. Observe the test job fail and the dependent image build/publish job be skipped.

This demonstrates how automated tests can prevent a failing change from being published.

## CV wording — use after you have run and verified the pipeline

**Python CI/CD Pipeline — GitHub Actions & Docker**
- Built a GitHub Actions workflow to automatically run Python unit tests on pushes and pull requests.
- Configured Docker image builds and automated publishing to GitHub Container Registry after successful tests on the `main` branch.
- Used workflow logs to inspect build and test results; packaged the application in a Docker container running as a non-root user.

Only include the CV bullets after you have successfully pushed the repository and verified a successful workflow run.
