# Base image
FROM ruby:2.5.0
EXPOSE 9292

# Setup environment variables that will be available to the instance
ENV APP_HOME /app

# Installation of dependencies
RUN apt-get update -qq && apt-get install -y \
      # Needed for certain gems
    build-essential \
         # Needed for postgres gem
    libpq-dev \
         # Needed for asset compilation
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

# Create a directory for our application
# and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Add our Gemfile
# and install gems
ADD Gemfile* $APP_HOME/
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Ensure all gems installed. Add binstubs to bin which has been added to PATH in Dockerfile.
RUN bundle package --all

# Copy over our application code
ADD . $APP_HOME

CMD bundle install --local && bundle exec rackup


