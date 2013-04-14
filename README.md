# Acts as Newsletter

This gem allows you to quickly implement a newsletter model without coding the
whole model management logic.

## Installation

Just add the gem to your Gemfile and bundle :

```ruby
gem "acts_as_newsletter"
```

To configure it, if needed, you can generate the default initializer with :

```bash
rails generate acts_as_newsletter:install
```

## Usage

Use the generator to generate the migration for your model :

```bash
# If your model is Newsletter
rails generate acts_as_newsletter newsletter
```

Now just add the `acts_as_newsletter` macro in your model, passing it a block
which returns a list of e-mail addresses to which the newsletter will be sent.

The block is passed the current Newsletter object so you can configure the way
emails are retrieved for each different newsletter :

```ruby
class Newsletter < ActiveRecord::Base
  belongs_to :emails_list

  acts_as_newsletter do |newsletter|
    emails newsletter.emails_list.emails.pluck(:email)
    # Assuming your mailer views are in app/views/newsletters/
    template_path "newsletters"
    # Set newsletters/newsletter.(html|text).erb
    layout "newsletter"
    # Get your mail template dynamically
    template_name newsletter.type.template
  end
end
```

## Sending it

Let's suppose you configured your `Newsletter` model, and created your mailer
view file, so everything is ready to be sent.

All what you need to do is to use the provided default rake task :

```bash
rake acts_as_newsletter:send_next
```

But wait ... it doesn't do anything by default since we can't know which model
is actually a newsletter - well we don't want `acts_as_newsletter` to know it -
and your sending logic may be custom. So the easiest way to configure it is to
uncomment the specified block in your
`config/initializers/acts_as_newsletter.rb` file and define your logic, or let
the default here :

```ruby
config.send_next = proc {
  Newsletter.send_next!
}
```

Now run `rake acts_as_newsletter:send_next` and it should send your e-mails !


## Licence

It uses MIT Licence so you can do whatever you want with it

