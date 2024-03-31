FROM ruby:3.2.3

# Node.js and Yarn installation
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y build-essential nodejs yarn vim zlib1g-dev liblzma-dev patch libvips42 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /app

WORKDIR /app

# Set development environment
ENV RAILS_ENV=development

# Copy Gemfile and Gemfile.lock
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install gems
RUN bundle lock --add-platform x86_64-linux \
    && gem install bundler -v 2.5.3 \
    && bundle install -j "$(getconf _NPROCESSORS_ONLN)"

# Copy the rest of the application
COPY . /app

# Configure entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Default command to start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
