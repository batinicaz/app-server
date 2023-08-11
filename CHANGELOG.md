# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [1.4.1](https://github.com/batinicaz/freshrss/compare/v1.4.0...v1.4.1) (2023-08-11)

## [1.4.0](https://github.com/batinicaz/freshrss/compare/v1.3.3...v1.4.0) (2023-08-11)


### Features

* support optionally updating nginx config for service ([95ea598](https://github.com/batinicaz/freshrss/commit/95ea598e34272873c1314204269e38f43b7803fe))

### [1.3.3](https://github.com/batinicaz/freshrss/compare/v1.3.2...v1.3.3) (2023-08-07)


### Bug Fixes

* add protocol to base_url to ensure correct redirects ([d4a5be0](https://github.com/batinicaz/freshrss/commit/d4a5be00871699653de602d2e3e458e3166d952e))

### [1.3.2](https://github.com/batinicaz/freshrss/compare/v1.3.1...v1.3.2) (2023-08-07)


### Bug Fixes

* set base_url for freshrss on boot ([894219a](https://github.com/batinicaz/freshrss/commit/894219a3785e225dfe1b3e27b7461273f2104ffc))

### [1.3.1](https://github.com/batinicaz/freshrss/compare/v1.3.0...v1.3.1) (2023-08-07)


### Bug Fixes

* move to ARM based instance as free tier includes more RAM ([333ae91](https://github.com/batinicaz/freshrss/commit/333ae911d63f9b032d9c74fe2c5a6adc96970af9))

## [1.3.0](https://github.com/batinicaz/freshrss/compare/v1.2.1...v1.3.0) (2023-08-06)


### Features

* set freshrss server_name on boot ([d4b6175](https://github.com/batinicaz/freshrss/commit/d4b6175e234eab2036bc4734972168b5972f1880))
* support additional services so long as mandatory services are included ([f8a18f4](https://github.com/batinicaz/freshrss/commit/f8a18f4e7c0aeff80595db9028ebfdcfe6c2b692))


### Bug Fixes

* backup sync task not running ([eedb46c](https://github.com/batinicaz/freshrss/commit/eedb46cbcfbb51730f37c2f3f2a3d9993cd9018d))
* regenerate auth key when instance rebuilt ([f5c0cf3](https://github.com/batinicaz/freshrss/commit/f5c0cf32c09c4ed59978aef01f061207bd8476b0))
* set correct fqdn for twitter replacements in nitter config ([a9ef7d2](https://github.com/batinicaz/freshrss/commit/a9ef7d27489ff197cf08ddc71f537547ef28222c))
* set display name of instance ([e33bad9](https://github.com/batinicaz/freshrss/commit/e33bad94e91d380f432bdb5dff9d31026e69506e))

### [1.2.1](https://github.com/batinicaz/freshrss/compare/v1.2.0...v1.2.1) (2023-08-05)


### Bug Fixes

* add permissions to create lifecycle rule ([f25b6ed](https://github.com/batinicaz/freshrss/commit/f25b6eda39360c2420feb82ab2df57704ae06982))

## [1.2.0](https://github.com/batinicaz/freshrss/compare/v1.1.0...v1.2.0) (2023-08-05)


### Features

* auto remove old backups ([52f9759](https://github.com/batinicaz/freshrss/commit/52f97596d3709c5e82d2a70cf3f0cadc8ced0915))


### Bug Fixes

* restore latest backup on boot ([1fd084e](https://github.com/batinicaz/freshrss/commit/1fd084e3178370217f1bf1fa1e14c20f9c814cba))

## 1.1.0 (2023-08-05)


### Features

* initial build of deployment ([53acad2](https://github.com/batinicaz/freshrss/commit/53acad24c051151a307b4019156a63560b37cfeb))
