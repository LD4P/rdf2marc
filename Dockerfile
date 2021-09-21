FROM ruby:2.7.2

WORKDIR /app
# # Operating system dependencies
RUN apt update && \
  apt install -y build-essential

# Application dependencies
COPY . /app

RUN bundle install --without development test
