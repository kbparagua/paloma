# Changelog

## Version 4.1.0
* Support for Turbolinks.
* `Paloma.executeHook()` to manually run the hook from the DOM.
* Paloma hook will be appended using all `render` calls, except for calls that has the following keys `[:json, :js, :xml, :file]`.
* Restore `Paloma.engine.start()` to start processing queued request.


## Version 4.0.0
* https://github.com/kbparagua/paloma/issues/26 - Paloma requests are not saved on `session`.
* https://github.com/kbparagua/paloma/issues/26 - Chaining with redirect is removed.
* Routing from javascript is removed.
* Routing from Rails controller is added.
* Ability to have a controller-wide setting.
* https://github.com/kbparagua/paloma/issues/29 - Disable `console.log` and `console.warn` for non-development environments.


## Version 3.0.2
* Bug Fix: Converting Rails controller name to singular form.


## Version 3.0.1
* Bug Fix: Can't handle Rails controller with Multi-word name.
* Bug Fix: Paloma Engine is halting when a warning is encountered.
* Don't create Paloma request if rendering js, json, xml, or file.


## Version 3.0.0
* Rewrite Initial Release
