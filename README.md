# BarelySearchable

This is a bare-bones almost functional "search" ability for your model layer.

It adds `.search` to your models which builds out a simple `LIKE OR` query to search your models and requires no external service to index the your tables or any index tables.

It is a terrible and slow search engine....but it'll probably work for a handful of use cases until you quit being lazy and install Sphinx.

## Installation

Add this line to your application's Gemfile: `gem 'barely_searchable'`

## Usage

In your model:

```
class User < ActiveRecord::Base
  #define the fields it'll search on
  searches_on :id, :username, :email, :first_name, :last_name
end
```

Now elsewhere in your application:

```
  def search_users
    @users = User.search 'user@domain.com'
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
