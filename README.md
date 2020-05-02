# Opentracing::Instrumented

OpenTracing instrumentation helpers.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "opentracing-instrumented"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install opentracing-instrumented

## Usage

Include the `OpenTracing::Instrumented` module in your class and call the
`traced` method with the methods you would like to start an span for. Each of
these methods will be called in an active span, where the operatioon will be
follow this format: `<class name>.<method name>`

```ruby
class MyOwnCommand
  include OpenTracing::Instrumented

  traced :call, :helper1, :helper2

  def call
    helper1
    helper2

    :ok
  end

  def helper1
  end

  def helper2
  end
end
```

Executing the code in the sample above will result in the following trace:

```text
<---------------------------------- parent span ---------------------------------->
  <----------------------------- MyOwnCommand.call ---------------------------->
    <------ MyOwnCommand.helper1 ------> <------ MyOwnCommand.helper2 ------>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/minond/ruby-opentracing-instrumented.


## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
