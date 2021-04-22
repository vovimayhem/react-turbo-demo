# Stage 1: Runtime =============================================================
# The minimal package dependencies required to run the app in the release image:

# Use the official Ruby 2.7.2 Slim Buster image as base:
FROM ruby:2.7.2-slim-buster AS runtime

# We'll set MALLOC_ARENA_MAX for optimization purposes & prevent memory bloat
# https://www.speedshop.co/2017/12/04/malloc-doubles-ruby-memory.html
ENV MALLOC_ARENA_MAX="2"

# We'll install curl for later dependency package installation steps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libpq5 \
    openssl \
    tzdata \
 && rm -rf /var/lib/apt/lists/*

# Stage 2: testing =============================================================
# This stage will contain the minimal dependencies for the CI/CD environment to
# run the test suite:

# Use the "runtime" stage as base:
FROM runtime AS testing

# Install gnupg, used to install node, but will also allow us to GPG sign our
# git commits when using the development image:
RUN apt-get update \
 && apt-get install -y --no-install-recommends gnupg2

# Add nodejs debian LTS repo:
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Add the Yarn debian repository:
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install the app build system dependency packages:
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    yarn

# Receive the app path as an argument:
ARG APP_PATH=/srv/react-turbo-demo

# Receive the developer user's UID and USER:
ARG DEVELOPER_UID=1000
ARG DEVELOPER_USERNAME=you

# Replicate the developer user in the development image:
RUN addgroup --gid ${DEVELOPER_UID} ${DEVELOPER_USERNAME} \
 ;  useradd -r -m -u ${DEVELOPER_UID} --gid ${DEVELOPER_UID} \
    --shell /bin/bash -c "Developer User,,," ${DEVELOPER_USERNAME}

# Ensure the developer user's home directory and APP_PATH are owned by him/her:
# (A workaround to a side effect of setting WORKDIR before creating the user)
RUN userhome=$(eval echo ~${DEVELOPER_USERNAME}) \
 && chown -R ${DEVELOPER_USERNAME}:${DEVELOPER_USERNAME} $userhome \
 && mkdir -p ${APP_PATH} \
 && chown -R ${DEVELOPER_USERNAME}:${DEVELOPER_USERNAME} ${APP_PATH}

# Add the app's "bin/" directory to PATH:
ENV PATH=${APP_PATH}/bin:$PATH

# Set the app path as the working directory:
WORKDIR ${APP_PATH}

# Change to the developer user:
USER ${DEVELOPER_USERNAME}

# Stage 3: Development =========================================================
# In this stage we'll add the packages, libraries and tools required in the
# day-to-day development process.

# Use the "testing" stage as base:
FROM testing AS development

# Receive the developer username again, as ARGS won't persist between stages on
# non-buildkit builds:
ARG DEVELOPER_USERNAME=you

# Change to root user to install the development packages:
USER root

# Install sudo, along with any other tool required at development phase:
RUN apt-get install -y --no-install-recommends \
  openssh-client \
  # Vim will be used to edit files when inside the container (git, etc):
  vim \
  # Sudo will be used to install/configure system stuff if needed during dev:
  sudo

# Add the developer user to the sudoers list:
RUN echo "${DEVELOPER_USERNAME} ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/${DEVELOPER_USERNAME}"

# Change back to the developer user:
USER ${DEVELOPER_USERNAME}
