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
rm layer.zip
zip -r layer.zip ruby/gems/2.7.0/
cd ../..
mv vendor/bundle/layer.zip .
```

## Generate a code zip.
```
rm -f lambda.zip
zip -r lambda.zip lib
zip -j lambda.zip lambda-s3/lambda_function.rb
```

## Copying zip files to AWS Production
```
aws s3 cp lambda.zip s3://sinopia-lambdas-production/sinopia-rdf2marc-production/ --profile developer --acl bucket-owner-full-control
aws s3 cp layer.zip s3://sinopia-lambdas-production/sinopia-rdf2marc-production/ --profile developer --acl bucket-owner-full-control
```
Check to see if the files are what you expect:
```
aws s3 ls s3://sinopia-lambdas-production/sinopia-rdf2marc-production/ --profile developer
```
