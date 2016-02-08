# Change Log

## [v1.2.0](https://github.com/codeforamerica/ohana-api/tree/v1.2.0) (2016-01-26)
[Full Changelog](https://github.com/codeforamerica/ohana-api/compare/v1.1.0...v1.2.0)

**Implemented enhancements:**

- Allow all CSV files to be exported in one click as a zip file. [\#326](https://github.com/codeforamerica/ohana-api/issues/326)
- Indicate Version in the Admin Backend [\#294](https://github.com/codeforamerica/ohana-api/issues/294)

**Fixed bugs:**

- Service name doesn't seem to be included in search index [\#364](https://github.com/codeforamerica/ohana-api/issues/364)

**Closed issues:**

- Difficulty importing large datasets [\#361](https://github.com/codeforamerica/ohana-api/issues/361)
- Repeated listings when setting service\_area [\#357](https://github.com/codeforamerica/ohana-api/issues/357)
- schema.rb not representative of migrations? [\#342](https://github.com/codeforamerica/ohana-api/issues/342)
- Add instructions for logging into Admin interface after having populated the database [\#340](https://github.com/codeforamerica/ohana-api/issues/340)
- Modelling many service providers at a location [\#337](https://github.com/codeforamerica/ohana-api/issues/337)
- Geocoder::OverQueryLimitError while importing locations, addresses [\#336](https://github.com/codeforamerica/ohana-api/issues/336)
- Trouble with CSV import [\#332](https://github.com/codeforamerica/ohana-api/issues/332)
- wiki page change has broken some links [\#330](https://github.com/codeforamerica/ohana-api/issues/330)

**Merged pull requests:**

- Update gems and fix style offenses [\#374](https://github.com/codeforamerica/ohana-api/pull/374) ([monfresh](https://github.com/monfresh))
- Update Rails version in README [\#373](https://github.com/codeforamerica/ohana-api/pull/373) ([monfresh](https://github.com/monfresh))
- Update dev gems [\#371](https://github.com/codeforamerica/ohana-api/pull/371) ([monfresh](https://github.com/monfresh))
- Update gems [\#370](https://github.com/codeforamerica/ohana-api/pull/370) ([monfresh](https://github.com/monfresh))
- Add before\_fork to disconnect from DB [\#369](https://github.com/codeforamerica/ohana-api/pull/369) ([monfresh](https://github.com/monfresh))
- Update dev gems [\#368](https://github.com/codeforamerica/ohana-api/pull/368) ([monfresh](https://github.com/monfresh))
- Update gems [\#367](https://github.com/codeforamerica/ohana-api/pull/367) ([monfresh](https://github.com/monfresh))
- Optimize import with no\_touching and SmarterCSV [\#362](https://github.com/codeforamerica/ohana-api/pull/362) ([monfresh](https://github.com/monfresh))
- Localize buttons [\#360](https://github.com/codeforamerica/ohana-api/pull/360) ([tannerj](https://github.com/tannerj))
- Eliminate duplicates when using service\_area [\#359](https://github.com/codeforamerica/ohana-api/pull/359) ([monfresh](https://github.com/monfresh))
- Add gems to assist in profiling app performance [\#356](https://github.com/codeforamerica/ohana-api/pull/356) ([monfresh](https://github.com/monfresh))
- Order results by updated\_at when rank is the same [\#355](https://github.com/codeforamerica/ohana-api/pull/355) ([monfresh](https://github.com/monfresh))
- Update Ruby to version 2.2.2 [\#353](https://github.com/codeforamerica/ohana-api/pull/353) ([monfresh](https://github.com/monfresh))
- Make dashboard\_spec more robust [\#352](https://github.com/codeforamerica/ohana-api/pull/352) ([monfresh](https://github.com/monfresh))
- Replace pg\_search with activerecord query [\#351](https://github.com/codeforamerica/ohana-api/pull/351) ([monfresh](https://github.com/monfresh))
- Update gems [\#350](https://github.com/codeforamerica/ohana-api/pull/350) ([monfresh](https://github.com/monfresh))
- Update sample csv files [\#348](https://github.com/codeforamerica/ohana-api/pull/348) ([monfresh](https://github.com/monfresh))
- Update deprecated command for Heroku addons [\#347](https://github.com/codeforamerica/ohana-api/pull/347) ([roughani](https://github.com/roughani))
- Allow DATABASE\_URL to be used for any enviroment [\#345](https://github.com/codeforamerica/ohana-api/pull/345) ([md5](https://github.com/md5))
- Provide one-click download of CSV files as a zip [\#343](https://github.com/codeforamerica/ohana-api/pull/343) ([monfresh](https://github.com/monfresh))
- Fix various issues with import script. [\#339](https://github.com/codeforamerica/ohana-api/pull/339) ([monfresh](https://github.com/monfresh))
- Remove remnants of WAD caching [\#338](https://github.com/codeforamerica/ohana-api/pull/338) ([md5](https://github.com/md5))
- Conditionally validate presence of state\_province [\#335](https://github.com/codeforamerica/ohana-api/pull/335) ([monfresh](https://github.com/monfresh))
- Disable email delivery during rake db:seed [\#334](https://github.com/codeforamerica/ohana-api/pull/334) ([monfresh](https://github.com/monfresh))
- Improve import script error handling. [\#333](https://github.com/codeforamerica/ohana-api/pull/333) ([monfresh](https://github.com/monfresh))
- Fix link to CSV files import wiki page [\#331](https://github.com/codeforamerica/ohana-api/pull/331) ([pmackay](https://github.com/pmackay))
- Use destroy\_all to remove test users and admins [\#329](https://github.com/codeforamerica/ohana-api/pull/329) ([md5](https://github.com/md5))
- Make meta description more generic for different Ohana deployments [\#328](https://github.com/codeforamerica/ohana-api/pull/328) ([md5](https://github.com/md5))
- Display Ohana API version for super admins. [\#327](https://github.com/codeforamerica/ohana-api/pull/327) ([monfresh](https://github.com/monfresh))

## [v1.1.0](https://github.com/codeforamerica/ohana-api/tree/v1.1.0) (2015-04-26)
[Full Changelog](https://github.com/codeforamerica/ohana-api/compare/v1.0...v1.1.0)

**Implemented enhancements:**

- Backup to CSV [\#304](https://github.com/codeforamerica/ohana-api/issues/304)

**Fixed bugs:**

- Admin with no ties to any entities should not see the "Add a new program" button. [\#308](https://github.com/codeforamerica/ohana-api/issues/308)

**Closed issues:**

- Add ability to copy a Service to other Locations [\#313](https://github.com/codeforamerica/ohana-api/issues/313)

**Merged pull requests:**

- Provide CSV downloads of table contents [\#325](https://github.com/codeforamerica/ohana-api/pull/325) ([monfresh](https://github.com/monfresh))
- Only validate state\_province length for US and CA [\#321](https://github.com/codeforamerica/ohana-api/pull/321) ([monfresh](https://github.com/monfresh))
- Prevent discovery of existing email addresses [\#320](https://github.com/codeforamerica/ohana-api/pull/320) ([monfresh](https://github.com/monfresh))
- Hide add new program for admin without access [\#318](https://github.com/codeforamerica/ohana-api/pull/318) ([monfresh](https://github.com/monfresh))
- Allow services to be copied to other locations. [\#317](https://github.com/codeforamerica/ohana-api/pull/317) ([monfresh](https://github.com/monfresh))
- Add Hound config and fix offenses. [\#316](https://github.com/codeforamerica/ohana-api/pull/316) ([monfresh](https://github.com/monfresh))
- Update Rails to version 4.2.1 [\#315](https://github.com/codeforamerica/ohana-api/pull/315) ([monfresh](https://github.com/monfresh))

## [v1.0](https://github.com/codeforamerica/ohana-api/tree/v1.0) (2015-03-27)
[Full Changelog](https://github.com/codeforamerica/ohana-api/compare/v0.3.1.0...v1.0)

**Implemented enhancements:**

- RFC: using the Pundit gem [\#215](https://github.com/codeforamerica/ohana-api/issues/215)
- Raise an error if required ENV vars are not set [\#180](https://github.com/codeforamerica/ohana-api/issues/180)

**Fixed bugs:**

- CSV import script should not fail if csv files are empty [\#284](https://github.com/codeforamerica/ohana-api/issues/284)
- demo admin test data is incorrect [\#247](https://github.com/codeforamerica/ohana-api/issues/247)
- Service area saving error [\#232](https://github.com/codeforamerica/ohana-api/issues/232)
- Search responds on any keyword match [\#101](https://github.com/codeforamerica/ohana-api/issues/101)

**Closed issues:**

- Location Website does not transfer to Service [\#307](https://github.com/codeforamerica/ohana-api/issues/307)
- Support query parameters for level of detail returned in search results [\#306](https://github.com/codeforamerica/ohana-api/issues/306)
- Documentation for Adding Services [\#305](https://github.com/codeforamerica/ohana-api/issues/305)
- /api and /admin routes are missing after app.json deployment [\#303](https://github.com/codeforamerica/ohana-api/issues/303)
- "No implicit conversion from true" error in application.yml during deployment [\#302](https://github.com/codeforamerica/ohana-api/issues/302)
- Can we move the "settings.yml" into the database? [\#301](https://github.com/codeforamerica/ohana-api/issues/301)
- Update spreadsheet example to match 0.8 spec [\#298](https://github.com/codeforamerica/ohana-api/issues/298)
- Add metadata tab to example data package spreadsheet [\#297](https://github.com/codeforamerica/ohana-api/issues/297)
- Subdirectories under /data [\#296](https://github.com/codeforamerica/ohana-api/issues/296)
- Discrepency between OpenReferral and Ohana [\#295](https://github.com/codeforamerica/ohana-api/issues/295)
- Validate CSV import files using CSVLint [\#285](https://github.com/codeforamerica/ohana-api/issues/285)
- RoutingError on Heroku [\#283](https://github.com/codeforamerica/ohana-api/issues/283)
- Dataset w/ No Taxonomy? [\#282](https://github.com/codeforamerica/ohana-api/issues/282)
- Generate CSV files from a Google Docs spreadsheet [\#281](https://github.com/codeforamerica/ohana-api/issues/281)
- Add "staging" environment in application.example.yml [\#279](https://github.com/codeforamerica/ohana-api/issues/279)
- Errors are getting lost in the `ImporterErrors.messages\_for\(obj\)` [\#277](https://github.com/codeforamerica/ohana-api/issues/277)
- Update vanity\_number in example location [\#274](https://github.com/codeforamerica/ohana-api/issues/274)
- Consider setting appropriate weekday date in `opens\_at` and `closes\_at` fields [\#273](https://github.com/codeforamerica/ohana-api/issues/273)
- Add all possible data to example location [\#272](https://github.com/codeforamerica/ohana-api/issues/272)
- Help with using the Admin Interface [\#260](https://github.com/codeforamerica/ohana-api/issues/260)
- Make sample\_data.json valid json [\#258](https://github.com/codeforamerica/ohana-api/issues/258)
- Super Admin cannot create new orgs, locations [\#254](https://github.com/codeforamerica/ohana-api/issues/254)
- already initialized constant APP\_PATH [\#246](https://github.com/codeforamerica/ohana-api/issues/246)
- Implement script that can populate the DB from Open Referral-compliant CSV files. [\#243](https://github.com/codeforamerica/ohana-api/issues/243)
- Strip extension delimiter from phone extension [\#241](https://github.com/codeforamerica/ohana-api/issues/241)
- 'Psychiatric Emergency' keyword in example data doesn't appear in search [\#240](https://github.com/codeforamerica/ohana-api/issues/240)
- Example data contains invalid entries [\#239](https://github.com/codeforamerica/ohana-api/issues/239)
- Update "Apps that are using the Ohana API" section in Readme [\#238](https://github.com/codeforamerica/ohana-api/issues/238)
- Update API and Admin interface to support fields defined in the OpenReferral spec. [\#236](https://github.com/codeforamerica/ohana-api/issues/236)
- Update "hack request" label to "help wanted" [\#230](https://github.com/codeforamerica/ohana-api/issues/230)
- Travis builds fail because of an error [\#203](https://github.com/codeforamerica/ohana-api/issues/203)
- Admin: Create 'Location' & 'Organization' does not throw errors when submitting blank form [\#200](https://github.com/codeforamerica/ohana-api/issues/200)
- Provide text for TTY off state [\#196](https://github.com/codeforamerica/ohana-api/issues/196)
- Provide phone number extension guidance [\#195](https://github.com/codeforamerica/ohana-api/issues/195)
- Make guidance text and button text the same for contacts [\#194](https://github.com/codeforamerica/ohana-api/issues/194)
- Add a contact should be visually separated from existing contacts [\#193](https://github.com/codeforamerica/ohana-api/issues/193)
- API documentation link in readme is a 404 [\#189](https://github.com/codeforamerica/ohana-api/issues/189)
- Admin: highlight fields with errors [\#188](https://github.com/codeforamerica/ohana-api/issues/188)
- Admin: add support for updating languages [\#187](https://github.com/codeforamerica/ohana-api/issues/187)
- Admin: Implement autocomplete or typeahead for organizations when adding new location [\#185](https://github.com/codeforamerica/ohana-api/issues/185)
- Add title attribute to all form inputs [\#184](https://github.com/codeforamerica/ohana-api/issues/184)
- Make the email address that sends the authentication emails customizable [\#182](https://github.com/codeforamerica/ohana-api/issues/182)
- Set up a static site to document the API [\#178](https://github.com/codeforamerica/ohana-api/issues/178)
- Relax validation constraints, allow adding incomplete data for correction later [\#174](https://github.com/codeforamerica/ohana-api/issues/174)
- Create more comprehensive Windows installation documentation [\#145](https://github.com/codeforamerica/ohana-api/issues/145)
- Update categories to use the latest Open Eligibility taxonomy [\#124](https://github.com/codeforamerica/ohana-api/issues/124)
- Categories and Kinds should be handled the same [\#104](https://github.com/codeforamerica/ohana-api/issues/104)
- Consider including ISO 639 language codes with the languages listed [\#99](https://github.com/codeforamerica/ohana-api/issues/99)
- Searches for the same term with and without a space should return same result set [\#93](https://github.com/codeforamerica/ohana-api/issues/93)
- Implement metrics for API client usage [\#86](https://github.com/codeforamerica/ohana-api/issues/86)
- Log changes in the DB [\#84](https://github.com/codeforamerica/ohana-api/issues/84)
- Use SSL for API and developer account portal [\#41](https://github.com/codeforamerica/ohana-api/issues/41)
- User views need styling love [\#37](https://github.com/codeforamerica/ohana-api/issues/37)
- Build a hypermedia API [\#35](https://github.com/codeforamerica/ohana-api/issues/35)
- Create a custom static HTML error page to replace Heroku's default [\#32](https://github.com/codeforamerica/ohana-api/issues/32)
- Create installation package [\#17](https://github.com/codeforamerica/ohana-api/issues/17)
- Create means to store temporary flagged/updated data [\#2](https://github.com/codeforamerica/ohana-api/issues/2)

**Merged pull requests:**

- Update Ruby to version 2.2.1 [\#314](https://github.com/codeforamerica/ohana-api/pull/314) ([monfresh](https://github.com/monfresh))
- Make application\_process optional to match OR 1.0 [\#310](https://github.com/codeforamerica/ohana-api/pull/310) ([monfresh](https://github.com/monfresh))
- Rename fields to match OpenReferral spec 1.0 [\#309](https://github.com/codeforamerica/ohana-api/pull/309) ([monfresh](https://github.com/monfresh))
- Add 'SMS' as a phone number type. [\#300](https://github.com/codeforamerica/ohana-api/pull/300) ([monfresh](https://github.com/monfresh))
- Add support for interpretation\_services field. [\#299](https://github.com/codeforamerica/ohana-api/pull/299) ([monfresh](https://github.com/monfresh))
- A bang, not a whimper [\#292](https://github.com/codeforamerica/ohana-api/pull/292) ([volkanunsal](https://github.com/volkanunsal))
- Add .gitattributes to enforce LF line endings. [\#291](https://github.com/codeforamerica/ohana-api/pull/291) ([monfresh](https://github.com/monfresh))
- Allow assigning Categories to a Service via CSV. [\#290](https://github.com/codeforamerica/ohana-api/pull/290) ([monfresh](https://github.com/monfresh))
- Add support for importing taxonomy via CSV. [\#289](https://github.com/codeforamerica/ohana-api/pull/289) ([monfresh](https://github.com/monfresh))
- Ignore CSV files that are not required. [\#287](https://github.com/codeforamerica/ohana-api/pull/287) ([monfresh](https://github.com/monfresh))
- Update bootstrap-sass to version 3.3.1.0 [\#286](https://github.com/codeforamerica/ohana-api/pull/286) ([monfresh](https://github.com/monfresh))
- Update caching [\#280](https://github.com/codeforamerica/ohana-api/pull/280) ([monfresh](https://github.com/monfresh))
- Expose weekday as integer. [\#276](https://github.com/codeforamerica/ohana-api/pull/276) ([monfresh](https://github.com/monfresh))
- Populate DB via OpenReferral-compliant CSV files. [\#275](https://github.com/codeforamerica/ohana-api/pull/275) ([monfresh](https://github.com/monfresh))
- Refactor regex validators. [\#271](https://github.com/codeforamerica/ohana-api/pull/271) ([monfresh](https://github.com/monfresh))
- Optimize admin decorator [\#270](https://github.com/codeforamerica/ohana-api/pull/270) ([monfresh](https://github.com/monfresh))
- Convert Location emails to singular email field. [\#269](https://github.com/codeforamerica/ohana-api/pull/269) ([monfresh](https://github.com/monfresh))
- Convert Location urls field to singular website. [\#268](https://github.com/codeforamerica/ohana-api/pull/268) ([monfresh](https://github.com/monfresh))
- Add API & Admin support for Service Phones. [\#267](https://github.com/codeforamerica/ohana-api/pull/267) ([monfresh](https://github.com/monfresh))
- Add API & Admin support for Organization Phones. [\#266](https://github.com/codeforamerica/ohana-api/pull/266) ([monfresh](https://github.com/monfresh))
- Add API & Admin support for Service Contacts. [\#265](https://github.com/codeforamerica/ohana-api/pull/265) ([monfresh](https://github.com/monfresh))
- Add admin & API support for Organization Contacts. [\#264](https://github.com/codeforamerica/ohana-api/pull/264) ([monfresh](https://github.com/monfresh))
- Add API & admin support for holiday schedules. [\#263](https://github.com/codeforamerica/ohana-api/pull/263) ([monfresh](https://github.com/monfresh))
- Add holiday\_schedules table. [\#262](https://github.com/codeforamerica/ohana-api/pull/262) ([monfresh](https://github.com/monfresh))
- Add regular schedules [\#259](https://github.com/codeforamerica/ohana-api/pull/259) ([monfresh](https://github.com/monfresh))
- Updates sample data [\#257](https://github.com/codeforamerica/ohana-api/pull/257) ([anselmbradford](https://github.com/anselmbradford))
- Set third admin to super admin in seeds.rb. [\#256](https://github.com/codeforamerica/ohana-api/pull/256) ([monfresh](https://github.com/monfresh))
- Add CRUD support for Programs in admin interface. [\#255](https://github.com/codeforamerica/ohana-api/pull/255) ([monfresh](https://github.com/monfresh))
- Add ability to filter locations by activity status [\#253](https://github.com/codeforamerica/ohana-api/pull/253) ([monfresh](https://github.com/monfresh))
- Optimize nearby endpoint. [\#252](https://github.com/codeforamerica/ohana-api/pull/252) ([monfresh](https://github.com/monfresh))
- Update root endpoint URLs. [\#251](https://github.com/codeforamerica/ohana-api/pull/251) ([monfresh](https://github.com/monfresh))
- Update services [\#249](https://github.com/codeforamerica/ohana-api/pull/249) ([monfresh](https://github.com/monfresh))
- Clarifies seed users roles [\#248](https://github.com/codeforamerica/ohana-api/pull/248) ([anselmbradford](https://github.com/anselmbradford))
- Updates readme [\#244](https://github.com/codeforamerica/ohana-api/pull/244) ([anselmbradford](https://github.com/anselmbradford))
- Remove unused custom pagination HTTP headers. [\#237](https://github.com/codeforamerica/ohana-api/pull/237) ([monfresh](https://github.com/monfresh))
- Add additional fields per v0.2 of HSDS [\#235](https://github.com/codeforamerica/ohana-api/pull/235) ([monfresh](https://github.com/monfresh))
- Use Select2 to update service keywords inline. [\#234](https://github.com/codeforamerica/ohana-api/pull/234) ([monfresh](https://github.com/monfresh))
- Use Select2 for service areas field. [\#233](https://github.com/codeforamerica/ohana-api/pull/233) ([monfresh](https://github.com/monfresh))
- Add support for updating languages. Closes \#187. [\#231](https://github.com/codeforamerica/ohana-api/pull/231) ([monfresh](https://github.com/monfresh))
- Allow admin to search for orgs via autocomplete. [\#229](https://github.com/codeforamerica/ohana-api/pull/229) ([monfresh](https://github.com/monfresh))
- Add multiple category search scenario spec. [\#228](https://github.com/codeforamerica/ohana-api/pull/228) ([monfresh](https://github.com/monfresh))
- Add support for searching on multiple languages. [\#227](https://github.com/codeforamerica/ohana-api/pull/227) ([monfresh](https://github.com/monfresh))
- expose the hypermedia headers in response [\#226](https://github.com/codeforamerica/ohana-api/pull/226) ([volkanunsal](https://github.com/volkanunsal))
- Specify subdomain for Devise mailers. [\#225](https://github.com/codeforamerica/ohana-api/pull/225) ([monfresh](https://github.com/monfresh))
- Move status controller into api namespace. [\#224](https://github.com/codeforamerica/ohana-api/pull/224) ([monfresh](https://github.com/monfresh))
- Highlight fields with errors & update validations. [\#222](https://github.com/codeforamerica/ohana-api/pull/222) ([monfresh](https://github.com/monfresh))
- Turn on SSL in production. Closes \#41. [\#221](https://github.com/codeforamerica/ohana-api/pull/221) ([monfresh](https://github.com/monfresh))
- Add service\_area filter. Closes \#51. [\#220](https://github.com/codeforamerica/ohana-api/pull/220) ([monfresh](https://github.com/monfresh))
- Add subdomain support for admin interface. [\#214](https://github.com/codeforamerica/ohana-api/pull/214) ([monfresh](https://github.com/monfresh))
- Upgrade Bootstrap to 3.2 & tweak admin interface. [\#213](https://github.com/codeforamerica/ohana-api/pull/213) ([monfresh](https://github.com/monfresh))
- Add wait time after deleting orgs/locs/services [\#212](https://github.com/codeforamerica/ohana-api/pull/212) ([monfresh](https://github.com/monfresh))
- Download gems from S3 without authorization. [\#211](https://github.com/codeforamerica/ohana-api/pull/211) ([monfresh](https://github.com/monfresh))
- Remove required attribute until we find workaround [\#208](https://github.com/codeforamerica/ohana-api/pull/208) ([monfresh](https://github.com/monfresh))
- Added visual indicators between repeated form objects [\#206](https://github.com/codeforamerica/ohana-api/pull/206) ([cndreisbach](https://github.com/cndreisbach))
- Added advice to the extension field on phone numbers [\#205](https://github.com/codeforamerica/ohana-api/pull/205) ([cndreisbach](https://github.com/cndreisbach))
- Added text for the negative state of a TTY number [\#202](https://github.com/codeforamerica/ohana-api/pull/202) ([cndreisbach](https://github.com/cndreisbach))
- Make authentication email addresses customizable [\#197](https://github.com/codeforamerica/ohana-api/pull/197) ([kjperry](https://github.com/kjperry))
- Refactor text\_search method. [\#190](https://github.com/codeforamerica/ohana-api/pull/190) ([monfresh](https://github.com/monfresh))
- Fix "label for" for categories. [\#183](https://github.com/codeforamerica/ohana-api/pull/183) ([monfresh](https://github.com/monfresh))

## [v0.3.1.0](https://github.com/codeforamerica/ohana-api/tree/v0.3.1.0) (2014-07-15)
[Full Changelog](https://github.com/codeforamerica/ohana-api/compare/v0.3.0.0...v0.3.1.0)

**Closed issues:**

- Many test failures in master branch [\#177](https://github.com/codeforamerica/ohana-api/issues/177)
- Add admin interface to API app [\#170](https://github.com/codeforamerica/ohana-api/issues/170)

**Merged pull requests:**

- Add Admin interface to API app [\#181](https://github.com/codeforamerica/ohana-api/pull/181) ([monfresh](https://github.com/monfresh))

## [v0.3.0.0](https://github.com/codeforamerica/ohana-api/tree/v0.3.0.0) (2014-06-27)
[Full Changelog](https://github.com/codeforamerica/ohana-api/compare/v0.2.0.0...v0.3.0.0)

**Implemented enhancements:**

- Search terms should map to nearest term in the database [\#23](https://github.com/codeforamerica/ohana-api/issues/23)

**Closed issues:**

- Sign Up Error:   Name can't be blank [\#164](https://github.com/codeforamerica/ohana-api/issues/164)
- application.example.yml code comment references file that does not exist [\#158](https://github.com/codeforamerica/ohana-api/issues/158)
- Add CONTRIBUTING.md [\#154](https://github.com/codeforamerica/ohana-api/issues/154)
- Notify all forkers about the updates to the repo [\#148](https://github.com/codeforamerica/ohana-api/issues/148)
- Replace MongoDB with Postgres [\#138](https://github.com/codeforamerica/ohana-api/issues/138)
- Geocoder::OverQueryLimitError [\#136](https://github.com/codeforamerica/ohana-api/issues/136)
- Sorting order varies when creation date of locations is the same [\#132](https://github.com/codeforamerica/ohana-api/issues/132)
- Provide instructions in application.yml that are consistent with readme [\#126](https://github.com/codeforamerica/ohana-api/issues/126)
- Add validations for phones field [\#125](https://github.com/codeforamerica/ohana-api/issues/125)
- Upgrade to Rails 4 [\#123](https://github.com/codeforamerica/ohana-api/issues/123)
- Add client libraries section to documentation [\#112](https://github.com/codeforamerica/ohana-api/issues/112)
- 'and' and '&' containing searches should be equivalent [\#81](https://github.com/codeforamerica/ohana-api/issues/81)
- Implement partial string match within a word [\#77](https://github.com/codeforamerica/ohana-api/issues/77)
- Add more validations for updating and creating new entries [\#66](https://github.com/codeforamerica/ohana-api/issues/66)

**Merged pull requests:**

- Remove grape dependency [\#176](https://github.com/codeforamerica/ohana-api/pull/176) ([monfresh](https://github.com/monfresh))
- Use script to store bundle on S3 for faster Travis runs [\#173](https://github.com/codeforamerica/ohana-api/pull/173) ([monfresh](https://github.com/monfresh))
- Update rspec-rails version to 3.0.1 & update specs. [\#172](https://github.com/codeforamerica/ohana-api/pull/172) ([monfresh](https://github.com/monfresh))
- lat\_lng search \(now with tests\) [\#171](https://github.com/codeforamerica/ohana-api/pull/171) ([dana11235](https://github.com/dana11235))
- Makes database naming consistent [\#169](https://github.com/codeforamerica/ohana-api/pull/169) ([anselmbradford](https://github.com/anselmbradford))
- Added note about user creation on Linux and Mac [\#167](https://github.com/codeforamerica/ohana-api/pull/167) ([migurski](https://github.com/migurski))
- Add user name to Devise permitted attributes. Fixes \#164. [\#165](https://github.com/codeforamerica/ohana-api/pull/165) ([monfresh](https://github.com/monfresh))
- Improve installation process and update documentation [\#163](https://github.com/codeforamerica/ohana-api/pull/163) ([monfresh](https://github.com/monfresh))
- Remove unused code [\#162](https://github.com/codeforamerica/ohana-api/pull/162) ([monfresh](https://github.com/monfresh))
- Remove Redis dependency [\#161](https://github.com/codeforamerica/ohana-api/pull/161) ([monfresh](https://github.com/monfresh))
- Add full-text search for org name [\#160](https://github.com/codeforamerica/ohana-api/pull/160) ([monfresh](https://github.com/monfresh))
- Add number\_type column to Phones table [\#156](https://github.com/codeforamerica/ohana-api/pull/156) ([monfresh](https://github.com/monfresh))
- Sort categories by oe\_id [\#155](https://github.com/codeforamerica/ohana-api/pull/155) ([monfresh](https://github.com/monfresh))
- Run migrations on Heroku after loading schema [\#153](https://github.com/codeforamerica/ohana-api/pull/153) ([monfresh](https://github.com/monfresh))
- Replace Elasticsearch with Postgres full-text search. Fixes \#139 [\#151](https://github.com/codeforamerica/ohana-api/pull/151) ([monfresh](https://github.com/monfresh))
- Make import rake task at least twice as fast [\#150](https://github.com/codeforamerica/ohana-api/pull/150) ([monfresh](https://github.com/monfresh))
- Upgrade grape-swagger gem to 0.7.2 [\#149](https://github.com/codeforamerica/ohana-api/pull/149) ([monfresh](https://github.com/monfresh))

## [v0.2.0.0](https://github.com/codeforamerica/ohana-api/tree/v0.2.0.0) (2014-04-16)
[Full Changelog](https://github.com/codeforamerica/ohana-api/compare/v0.1.0.0...v0.2.0.0)

**Implemented enhancements:**

- Create top-level endpoint that describes all API endpoints [\#40](https://github.com/codeforamerica/ohana-api/issues/40)

**Fixed bugs:**

- South San Francisco Senior Services geocoded to Oakland [\#108](https://github.com/codeforamerica/ohana-api/issues/108)
- Languages listed in 'Palo Alto Family YMCA' service\_areas [\#97](https://github.com/codeforamerica/ohana-api/issues/97)
- Admin interface lists kind as "Other" when no kind value has been assigned [\#94](https://github.com/codeforamerica/ohana-api/issues/94)

**Closed issues:**

- TTY Phone Numbers [\#146](https://github.com/codeforamerica/ohana-api/issues/146)
- Please confirm link to current requirements? [\#144](https://github.com/codeforamerica/ohana-api/issues/144)
- Move ohanapi.org to separate repo [\#142](https://github.com/codeforamerica/ohana-api/issues/142)
- Document need for paid Elasticsearch add-on on Heroku [\#140](https://github.com/codeforamerica/ohana-api/issues/140)
- Short Descriptions Longer than 200 Characters [\#137](https://github.com/codeforamerica/ohana-api/issues/137)
- Farmers' Markets are missing service area in admin interface [\#134](https://github.com/codeforamerica/ohana-api/issues/134)
- Meta Field in JSON Response [\#131](https://github.com/codeforamerica/ohana-api/issues/131)
- Example search URLs in readme return empty result sets [\#129](https://github.com/codeforamerica/ohana-api/issues/129)
- Example URL in readme generates route error [\#128](https://github.com/codeforamerica/ohana-api/issues/128)
- Many spec failures on master [\#121](https://github.com/codeforamerica/ohana-api/issues/121)
- Move issues that are specific to SMC to a new fork [\#120](https://github.com/codeforamerica/ohana-api/issues/120)
- CIP Portal link broken on README.md [\#118](https://github.com/codeforamerica/ohana-api/issues/118)
- Some YMCA branches are kind `Sports` some are `Other` [\#116](https://github.com/codeforamerica/ohana-api/issues/116)
- Add kind to farmers' markets json or use different field to check for validation [\#115](https://github.com/codeforamerica/ohana-api/issues/115)
- Make Elasticsearch point to add-on via generic ENV variable [\#114](https://github.com/codeforamerica/ohana-api/issues/114)
- Add data dictionary to documentation [\#113](https://github.com/codeforamerica/ohana-api/issues/113)
- Add a "press" section on ohanapi.org [\#111](https://github.com/codeforamerica/ohana-api/issues/111)
- Look into Mozilla Persona as a way to create accounts for admin interface [\#110](https://github.com/codeforamerica/ohana-api/issues/110)
- United States Government agencies not listed under Government kind [\#109](https://github.com/codeforamerica/ohana-api/issues/109)
- search for food in farmers' markets returns no results [\#106](https://github.com/codeforamerica/ohana-api/issues/106)
- Showcase projects that are using the API [\#103](https://github.com/codeforamerica/ohana-api/issues/103)
- Link to API documentation from within developer portal [\#102](https://github.com/codeforamerica/ohana-api/issues/102)
- Figure out the proper ES mapping and search queries to have exact matches appear first [\#100](https://github.com/codeforamerica/ohana-api/issues/100)
- Entries with mailing address only should not have coordinates [\#96](https://github.com/codeforamerica/ohana-api/issues/96)
- SFMNP search should return farmer's markets that accept SFMNP [\#95](https://github.com/codeforamerica/ohana-api/issues/95)
- Kind field should be consistent plural or singular [\#92](https://github.com/codeforamerica/ohana-api/issues/92)
- Entries that have an apparent "department" value in the name should list that last [\#90](https://github.com/codeforamerica/ohana-api/issues/90)
- Safe Baby Surrender locations [\#82](https://github.com/codeforamerica/ohana-api/issues/82)
- URLs in CIP data should all have "http://" [\#74](https://github.com/codeforamerica/ohana-api/issues/74)
- SF, Little People of America website needs to be updated [\#73](https://github.com/codeforamerica/ohana-api/issues/73)
- `Contractors State License Board` has redundant ask\_for entries [\#71](https://github.com/codeforamerica/ohana-api/issues/71)
- Map CIP keywords to OpenEligibility terms [\#45](https://github.com/codeforamerica/ohana-api/issues/45)
- Add and identify organizations that provide ongoing CalFresh application assistance [\#44](https://github.com/codeforamerica/ohana-api/issues/44)
- Improve the copy in the Devise views and emails [\#38](https://github.com/codeforamerica/ohana-api/issues/38)
- Needs to handle concurrent update sessions [\#8](https://github.com/codeforamerica/ohana-api/issues/8)
- Implement authenticated queries for writing data [\#7](https://github.com/codeforamerica/ohana-api/issues/7)

**Merged pull requests:**

- Mongo to Postgres migration [\#147](https://github.com/codeforamerica/ohana-api/pull/147) ([monfresh](https://github.com/monfresh))
- Add admin field to location [\#143](https://github.com/codeforamerica/ohana-api/pull/143) ([monfresh](https://github.com/monfresh))
- Remove short description validations [\#141](https://github.com/codeforamerica/ohana-api/pull/141) ([monfresh](https://github.com/monfresh))
- Readme updates [\#130](https://github.com/codeforamerica/ohana-api/pull/130) ([anselmbradford](https://github.com/anselmbradford))
- waffle.io Badge [\#122](https://github.com/codeforamerica/ohana-api/pull/122) ([waffleio](https://github.com/waffleio))
- Fixes \#118 [\#119](https://github.com/codeforamerica/ohana-api/pull/119) ([anselmbradford](https://github.com/anselmbradford))
- Travis needs this hook to update project monitor [\#117](https://github.com/codeforamerica/ohana-api/pull/117) ([pui](https://github.com/pui))

## [v0.1.0.0](https://github.com/codeforamerica/ohana-api/tree/v0.1.0.0) (2013-09-13)
[Full Changelog](https://github.com/codeforamerica/ohana-api/compare/v0.1...v0.1.0.0)

**Fixed bugs:**

- Find all leads to a 500 error [\#88](https://github.com/codeforamerica/ohana-api/issues/88)

**Closed issues:**

- Format accessibility options for display [\#85](https://github.com/codeforamerica/ohana-api/issues/85)
- Make API hostname app-local [\#83](https://github.com/codeforamerica/ohana-api/issues/83)
- All terms shown on homepage should return at least one result [\#80](https://github.com/codeforamerica/ohana-api/issues/80)
- Data needs to be modeled differently [\#64](https://github.com/codeforamerica/ohana-api/issues/64)

## [v0.1](https://github.com/codeforamerica/ohana-api/tree/v0.1) (2013-08-28)
**Implemented enhancements:**

- Implement elastic search for keyword search [\#46](https://github.com/codeforamerica/ohana-api/issues/46)
- Conditional requests that return 304/Not Modified should not count against rate limit [\#34](https://github.com/codeforamerica/ohana-api/issues/34)
- Securing API - implement email tracking [\#26](https://github.com/codeforamerica/ohana-api/issues/26)
- Securing API - implement token support [\#25](https://github.com/codeforamerica/ohana-api/issues/25)
- Sort and order parameter should be available in search query [\#20](https://github.com/codeforamerica/ohana-api/issues/20)
- Need API usage examples [\#18](https://github.com/codeforamerica/ohana-api/issues/18)
- gh-pages branch needs optimizing for mobile [\#16](https://github.com/codeforamerica/ohana-api/issues/16)

**Fixed bugs:**

- Nearby endpoint returns system error instead of empty result set [\#78](https://github.com/codeforamerica/ohana-api/issues/78)
- San Jose Taiko has array for street\_address [\#67](https://github.com/codeforamerica/ohana-api/issues/67)
- Primrose Center has incorrect phones array [\#60](https://github.com/codeforamerica/ohana-api/issues/60)
- regex for phones should handle extensions [\#53](https://github.com/codeforamerica/ohana-api/issues/53)
- Search for "san carlos" returns no results. [\#50](https://github.com/codeforamerica/ohana-api/issues/50)
- Search for "food" and "food " returns different results. [\#49](https://github.com/codeforamerica/ohana-api/issues/49)
- Searching for a 6-digit zip code should result in a bad request [\#48](https://github.com/codeforamerica/ohana-api/issues/48)
- Empty location parameter should be ignored [\#33](https://github.com/codeforamerica/ohana-api/issues/33)

**Closed issues:**

- Remove redundant keywords [\#79](https://github.com/codeforamerica/ohana-api/issues/79)
- /nearby/ endpoint should provide pagination structure consistent with /organizations/ endpoint [\#75](https://github.com/codeforamerica/ohana-api/issues/75)
- Dev portal "Create a new application" text should be a link. [\#69](https://github.com/codeforamerica/ohana-api/issues/69)
- JSON created from CIP data should include the "Mail" field as the street address [\#65](https://github.com/codeforamerica/ohana-api/issues/65)
- How to Apply and Fees fields missing periods [\#61](https://github.com/codeforamerica/ohana-api/issues/61)
- ask\_for field is not an array in many cases [\#59](https://github.com/codeforamerica/ohana-api/issues/59)
- phones vs phone [\#56](https://github.com/codeforamerica/ohana-api/issues/56)
- create full organization entries for testing [\#52](https://github.com/codeforamerica/ohana-api/issues/52)
- Name value should have period removed [\#47](https://github.com/codeforamerica/ohana-api/issues/47)
- Set up an email delivery service add-on on Heroku [\#43](https://github.com/codeforamerica/ohana-api/issues/43)
- Database values should not include punctuation [\#30](https://github.com/codeforamerica/ohana-api/issues/30)
- service hours vs business hours [\#28](https://github.com/codeforamerica/ohana-api/issues/28)
- Return a list of nearby locations when querying a specific organization [\#15](https://github.com/codeforamerica/ohana-api/issues/15)
- Add fields to DB [\#14](https://github.com/codeforamerica/ohana-api/issues/14)
- Build wrappers for the API [\#13](https://github.com/codeforamerica/ohana-api/issues/13)
- Data loader needs to be more robust [\#12](https://github.com/codeforamerica/ohana-api/issues/12)
- Add pagination info to the Link header [\#11](https://github.com/codeforamerica/ohana-api/issues/11)
- Reject requests that don't contain a valid User Agent string [\#10](https://github.com/codeforamerica/ohana-api/issues/10)
- Needs to support versioning [\#6](https://github.com/codeforamerica/ohana-api/issues/6)
- Needs to support pagination [\#5](https://github.com/codeforamerica/ohana-api/issues/5)
- Create initial Rails API architecture. [\#1](https://github.com/codeforamerica/ohana-api/issues/1)

**Merged pull requests:**

- Elasticsearch [\#76](https://github.com/codeforamerica/ohana-api/pull/76) ([monfresh](https://github.com/monfresh))
- Add link to create a new application on developer portal. Fixes \#69 [\#70](https://github.com/codeforamerica/ohana-api/pull/70) ([monfresh](https://github.com/monfresh))
- Add nearby endpoint for locations near the one queried. Fixes \#15. [\#68](https://github.com/codeforamerica/ohana-api/pull/68) ([monfresh](https://github.com/monfresh))
- Require valid user agent in request. Fixes \#10 [\#42](https://github.com/codeforamerica/ohana-api/pull/42) ([monfresh](https://github.com/monfresh))
- Fixes \#25 and \#26 [\#39](https://github.com/codeforamerica/ohana-api/pull/39) ([monfresh](https://github.com/monfresh))
- Add sort and order search parameters [\#27](https://github.com/codeforamerica/ohana-api/pull/27) ([monfresh](https://github.com/monfresh))
- added more db fields [\#21](https://github.com/codeforamerica/ohana-api/pull/21) ([spara](https://github.com/spara))
- Changed "Development" to "Installation" in header [\#3](https://github.com/codeforamerica/ohana-api/pull/3) ([migurski](https://github.com/migurski))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
