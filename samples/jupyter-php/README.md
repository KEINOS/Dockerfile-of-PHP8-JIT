# Jupyter-PHP

[Sample Dockerfile](./Dockerfile) to use [Jupyter](https://jupyter.org/) with PHP8 Kernel using Jupyter-PHP.

- [Jupyter-PHP](https://github.com/Litipk/Jupyter-PHP) @ GitHub

## Usage

### Build image

```bash
docker build -t jupyter:local .
```

### Run container

```bash
docker run -p 8001:8000 jupyter:local
```

Don't forget to publish the port as `-p 8001:8000`. This will port-forward the #8001 port of your `localhost` to the #8000 port of the container in the Docker network.

If the 8001 port is already in use, then change it to any unused port of your local machine.

After the web server launches, a token will be displayed. Copy it and access the Jupyter lab container from your browser with the provided token. (See the sample usage section)

#### Share data directory

If you want the notebook saved in your local, then you need to mount a directory as a volume to `/workspace` in the container.

```bash
docker run -p 8001:8000 -v $(pwd)/data:/workspace jupyter:local
```

#### To access container

You can access the container from Jupyter's terminal via the web browser. But if you want to interact locally, not booting the Jupyter lab, then specify the shell.

```bash
docker run --rm -it --entrypoint /bin/sh
```

## Sample usage

```shellsession
$ docker run --rm -it -p 8001:8000 -v $(pwd)/data:/workspace jupyter:local
[I 09:19:03.520 LabApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 09:19:04.470 LabApp] JupyterLab extension loaded from /usr/local/lib/python3.9/site-packages/jupyterlab
[I 09:19:04.470 LabApp] JupyterLab application directory is /usr/local/share/jupyter/lab
[I 09:19:04.475 LabApp] Serving notebooks from local directory: /workspace
[I 09:19:04.475 LabApp] Jupyter Notebook 6.1.4 is running at:
[I 09:19:04.475 LabApp] http://a9b6b6cde2b3:8000/?token=2c7a9b0dce099eb8c2571072e51b0bce499143dab0aff271
[I 09:19:04.476 LabApp]  or http://127.0.0.1:8000/?token=2c7a9b0dce099eb8c2571072e51b0bce499143dab0aff271
[I 09:19:04.476 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 09:19:04.488 LabApp]

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://a9b6b6cde2b3:8000/?token=2c7a9b0dce099eb8c2571072e51b0bce499143dab0aff271
     or http://127.0.0.1:8000/?token=2c7a9b0dce099eb8c2571072e51b0bce499143dab0aff271

# In the case above the URL to access from your browser will be:
#   http://localhost:8001/?token=2c7a9b0dce099eb8c2571072e51b0bce499143dab0aff271
```

## Note

- OS: Alpine Linux
- User: `root`
- Default port # of Jupyter to listen: 8000
- List of Jupyter services installed:
  - jupyter core
  - jupyter-notebook
  - qtconsole
  - ipython
  - ipykernel
  - jupyter client
  - jupyter lab
  - nbconvert
  - pywidgets
  - nbformat
  - traitlets

## Troubleshoot

If you get "`Clearing invalid/expired login cookie username-localhost-XXXX`" error while booting the container, then check if someone isn't accessing the container (opening the browser). If so, then close it and try again. The user is trying to access with the old token.
