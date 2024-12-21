# Use the official Ruby image as the base
FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set environment variables
ENV RAILS_ENV=development
ENV RACK_ENV=development

# Create and set the working directory
RUN mkdir /myapp
WORKDIR /myapp

# Install gems
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler && bundle install

# Copy the rest of the application code
COPY . /myapp

# Precompile assets (optional, mainly for production)
# RUN bundle exec rake assets:precompile

# Expose port 3000 to the host
EXPOSE 3000

# Start the Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
