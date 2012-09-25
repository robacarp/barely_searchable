# BarelySearchable

This is a bare-bones "search" function for your model layer.  Use with care, this is sequel trickery.

It adds `.search` to your models which builds out a simple `LIKE OR` type query to search your models and requires no external service (eg. sphinx) to index the your tables or any index tables.

As far as search engines go, this isn't very clever. It'll work for a handful of use cases, at least until you quit being lazy and install Sphinx.  :D

## Installation

Add this line to your application's Gemfile: `gem 'barely_searchable'`

## Quickstart

In your model:

```
class User < ActiveRecord::Base
  #define the fields it'll search on
  searches_on :id, :username, :email, :first_name, :last_name
end

class Entry < ActiveRecord::Base
  searches_on :title, :body
end
```

Now elsewhere in your application:

```
  def search_users
    @users = User.search 'user@domain.com'
  end
  
  def search_blogs
    #Regular model querying methods still work just fine.
    @entries = Entry.with_permissions_to(:show).search("friendship is unnecessary, like philosophy").limit(15)
  end
```

## More details

In your models, you can specify conditions on the search parameters to exclude them from searches.  This is useful for search query optimization or selective searches.

```
class Order < ActiveRecord::Base
  #search these columns always
  searches_on :user_id, :shipping_city

  # Will only search these columns when the type-casted value isn't zero
  searches_on :subtotal, :tax, :total, unless: Proc.new{|value| value == 0}

  # Only search this column if the query is longer thahn 3 characters
  searches_on :email, if: Proc.new{|value| value.length > 3}
end
```

Search content is cast to the column data type before calling if/unless blocks.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
