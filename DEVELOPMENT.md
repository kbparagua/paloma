# Development

## Testing

1. Go to `test_app`
1. Comment out `turbolinks.js` on `applciation.js`
1. Run `bundle exec rails s`.
1. Open your browser and visit [http://localhost:3000/specs](http://localhost:3000/specs).
1. Run `bundle exec rake spec:units`.
1. Run `bundle exec rake spec:integration`.

## TODO

1. Improve tests.
1. Testing for turbolinks.
