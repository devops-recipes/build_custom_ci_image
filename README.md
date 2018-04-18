# Build a Ubuntu 16.04 with Java 8 custom CI image that can be used for Shippable CI

In most cases, your CI workflow should work fine with our official images which are used by default. However, you might want to consider using a custom Docker image in the following situations:

* Your build has dependencies that take a long time to install if installed as part of your CI workflow.
* You want to build a project written in a language not officially supported by Shippable.
* You are using a combination of languages and tools not supported together in any official images.
* You want to run CI in your own Docker image to better simulate your production environment.

This sample shows you how you can build a custom Docker image which can then be used to execute your CI workflow. The complete tutorial is at http://docs.shippable.com/ci/tutorial/build-custom-ci-image/
