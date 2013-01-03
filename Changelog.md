Changelog
=

Version 1.1.0
-
* Handle namespaced controllers: `rails g paloma:add namespace/controller action`

Version 1.0.0
-
* `AddGenerator` changed from `rails g paloma:add controller/action` to `rails g paloma:add controller action`

Version 0.0.8
-
* Bug Fix: _callback.js cannot find _local.js

Version 0.0.7
-
* Fix A Major Bug that copies the _local.js template instead of _callbacks.js

Version 0.0.6
-
* `SetupGenerator` moved from `paloma_generator.rb` to `paloma/generators/setup_generator.rb`
* `AddGenerator` moved from `paloma_generator` to `paloma/generators/add_generator.rb`
* Refactored both generators
* Test for both generators

Version 0.0.5
-
* Callbacks are executed after the DOM is ready

Version 0.0.4
-
* First release
