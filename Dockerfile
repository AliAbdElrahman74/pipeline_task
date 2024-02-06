# Use the official Ruby image
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /app

# Set up Node.js repository and install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs npm

# Set up Yarn repository and install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y yarn

# RUN npm install -g esbuild nodemon
# Install bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install
RUN bundle exec rails db:setup

# Copy the rest of the application code to the container
COPY . .

RUN yarn install

# Expose port 3005 to the Docker host, so it can be accessed from the outside
EXPOSE 3005

# Set up a volume for the MySQL data
VOLUME /var/lib/mysql

# Start the Rails server
CMD ["bin/dev"]
