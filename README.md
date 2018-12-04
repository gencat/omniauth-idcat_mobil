# Omniauth::IdcatMobil

User registration and login through IdCat mòbil, an authentication method that uses OAuth 2.0 protocol.
_IdCat mòbil_ is an identity validator from VÀLid (Validador d'Identitats del Consorci AOC).

Further information: https://web.gencat.cat/ca/tramits/com-tramitar-en-linia/identificacio-digital/id-cat-mobil

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-idcat_mobil'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-idcat_mobil

## Usage

Users must be registered at _IdCat mòbil_. To do so, you can register online or offline, check how [here]( https://web.gencat.cat/ca/tramits/com-tramitar-en-linia/identificacio-digital/id-cat-mobil/#bloc2).

Next, tell OmniAuth about this strategy. In a Rails application using Devise you would create a file like config/initializers/omniauth_idcat_mobil.rb with this code:

```ruby
Devise.setup do |config|
  config.omniauth :idcat_mobil,
                  ENV["IDCAT_MOBIL_CLIENT_ID"],
                  ENV["IDCAT_MOBIL_CLIENT_SECRET"],
                  ENV["IDCAT_MOBIL_SITE_URL"],
                  scope: :autenticacio_usuari
end
```

`omniauth-idcat_mobil` is a standard OAuth2 strategy. It is based on `omniauth-oauth2` that is just an `omniauth` extension. Thus, you can also integrate it using [`omniauth` integrating guide](https://github.com/omniauth/omniauth).

## Incon assets
We're including _IdCat mòbil_ icons in lib/decidim/idcat_mobil for the joy of the developer. They can be used to complement the OAuth2 button or alike.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/omniauth-idcat_mobil. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Omniauth::IdcatMobil project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/omniauth-idcat_mobil/blob/master/CODE_OF_CONDUCT.md).
