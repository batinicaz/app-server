# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [1.8.2](https://github.com/batinicaz/freshrss/compare/v1.8.1...v1.8.2) (2024-05-27)


### Bug Fixes

* bootstrap script ([6d4bea3](https://github.com/batinicaz/freshrss/commit/6d4bea35affdaca5e63feb0d97deec5220ed8231))
* update nginx config following oci image change from nginx to openresty ([82e3af5](https://github.com/batinicaz/freshrss/commit/82e3af52f1dfa055d76c309fda4c6e36a0ae36d7))

### [1.8.1](https://github.com/batinicaz/freshrss/compare/v1.8.0...v1.8.1) (2024-05-27)


### Bug Fixes

* restoring planka config on boot ([369336f](https://github.com/batinicaz/freshrss/commit/369336fbf25f2927bbc39f92412c557524deba00))

## [1.8.0](https://github.com/batinicaz/freshrss/compare/v1.7.1...v1.8.0) (2024-05-27)


### Features

* add planka ([3da5c0a](https://github.com/batinicaz/freshrss/commit/3da5c0a095eaafa503d3ee23f9c9dc138bf9e4b5))

### [1.7.1](https://github.com/batinicaz/freshrss/compare/v1.7.0...v1.7.1) (2024-04-06)


### Bug Fixes

* remove redundant CRON job - deletion of local backups done in image ([64f0f4d](https://github.com/batinicaz/freshrss/commit/64f0f4d55156ef5de36b91bf431489c923476b73))

## [1.7.0](https://github.com/batinicaz/freshrss/compare/v1.6.1...v1.7.0) (2024-03-14)


### Features

* add support for redlib and dynamic waf blocking per service ([d5a405a](https://github.com/batinicaz/freshrss/commit/d5a405a13e8ff7a97f60e2a3f8998ae6658b39f7))

### [1.6.1](https://github.com/batinicaz/freshrss/compare/v1.6.0...v1.6.1) (2024-02-13)


### Bug Fixes

* add job to remove local copies of deleted backups to prevent re-uploading deleted backups ([7d0e7f9](https://github.com/batinicaz/freshrss/commit/7d0e7f9368018ee3f79fef6c0072fb73d556947f))

## [1.6.0](https://github.com/batinicaz/freshrss/compare/v1.5.3...v1.6.0) (2024-02-02)


### Features

* move hcp_packer_image to hcp_packer_artifact following deprecation ([98063d3](https://github.com/batinicaz/freshrss/commit/98063d398b113dacdc684d2960e601077e494401))
* reduce backups retention ([fa052da](https://github.com/batinicaz/freshrss/commit/fa052da16a7a00c74c7ba0f120f5a61282e045f4))

### [1.5.3](https://github.com/batinicaz/freshrss/compare/v1.5.2...v1.5.3) (2023-12-20)


### Bug Fixes

* remove double escaping left over from terraform that caused nitter bootstrap to not run correctly ([b811208](https://github.com/batinicaz/freshrss/commit/b811208e19fd39d9c1b3408e54c832d7e239391f))

### [1.5.2](https://github.com/batinicaz/freshrss/compare/v1.5.1...v1.5.2) (2023-11-02)


### Bug Fixes

* encode bootstrap script in user data ([7b3faa6](https://github.com/batinicaz/freshrss/commit/7b3faa68c0cea33afff1810a67e7d3b515ff3412))

### [1.5.1](https://github.com/batinicaz/freshrss/compare/v1.5.0...v1.5.1) (2023-11-02)


### Bug Fixes

* retry download of backups + move backups to new bucket without retention rules to avoid never deleting backups ([a62549e](https://github.com/batinicaz/freshrss/commit/a62549ec5e4718bfa244234a0f34bfe80cb0af52))

## [1.5.0](https://github.com/batinicaz/freshrss/compare/v1.4.1...v1.5.0) (2023-08-30)


### Features

* restrict access to nitter to protect usage of guest_accounts ([e6153d4](https://github.com/batinicaz/freshrss/commit/e6153d42d4ff0e4db450654f82073501bc98a588))

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
