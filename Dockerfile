FROM condaforge/mambaforge:latest

# The HF Space container runs with user ID 1000.
RUN useradd -m -u 1000 user
USER user

# Set home to the user's home directory
ENV HOME=/home/user \
  PATH=/home/user/.local/bin:$PATH

# Set the working directory to the user's home directory
WORKDIR $HOME/app
COPY --chown=user . .

# Create the environment
RUN mamba env create --prefix $HOME/env -f ./environment.yml

# ✅ Add this block to install/enable JS widget extensions
RUN mamba run -p $HOME/env pip install \
    ipywidgets \
    jupyterlab_widgets \
    widgetsnbextension

EXPOSE 7860
WORKDIR $HOME/app

# Start Voilà from the notebooks/ directory
CMD mamba run -p $HOME/env --no-capture-output voila --no-browser notebooks/
