Changelog
=

Version 2.0.3
-
* Bug Fix: prevent javascript error when callback doesn't exist.

Version 2.0.2
-
* 'js(false)' will prevent Paloma from appending _callback_hook on the response.

Version 2.0.1
-
* Bug Fix: `params` is not passed when calling filters.

Version 2.0.0
-
* Change `js_callback` to `js` only.
* Request and Callback details are automatically included on `params` (example: controller, action, namespace, controller_path, etc...)
* Hooks for Rails controller and scaffold generators.
* Change `Paloma.callbacks['namespace/controller/action']` to `Paloma.callbacks['namespace/controller']['action']`.
* `paloma.js` file removed.
* `_callbacks.js` renamed to `_manifest.js`.
* `_local.js` renamed to `_locals.js`.
* Filters are now available (before_filter, after_filter, and around_filter).
* Skip filters are now available (skip_before_filter, skip_after_filter, skip_around_filter).
* Locals can now be easily accessible using the `_l` object.
* Issue javascript warning instead of javascript error when Paloma is not included on `application.js`.
* Codes are now inside closures, to prevent variable clashes.

Version 1.2.0
-
* AddGenerator with multiple actions: `rails g paloma:add namespace/controller action1 action2 action3`

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
