# rdf2marc as an AWS Lambda

The following are some notes on preparing to deploy rdf2marc as an AWS Lambda.

All instructions are to be run from the root of the project.

## Generate a layer zip.
The layer contains the dependencies.
```
rm -fr vendor
mkdir -p vendor/bundle
docker run -it --rm -v "$PWD/vendor":"/var/task/vendor" -v "$PWD/Gemfile":"/var/task/Gemfile" -v "$PWD/Gemfile.lock":"/var/task/Gemfile.lock" lambci/lambda:build-ruby2.7 bundle install --path vendor/bundle
cd vendor/bundle
mkdir ruby/gems
mv ruby/2.7.0 ruby/gems/
rm gem_layer.zip
zip -r gem_layer.zip ruby/gems/2.7.0/
cd ../..
mv vendor/bundle/gem_layer.zip .
```

## Generate a code zip.
```
rm -f lambda.zip
zip -r lambda.zip lib
zip -j lambda.zip lambda/lambda_function.rb
```