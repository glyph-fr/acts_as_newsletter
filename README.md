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

```
class Newsletter < ActiveRecord::Base
  belongs_to :emails_list

  acts_as_newsletter do |newsletter|
    emails newsletter.emails_list.emails.pluck(:email)
    # Assuming your mailer views are in app/views/newsletters/
    template_path "newsletters"
    # Set newsletters/newsletter.(html|text).(erb|haml)
    layout "newsletter"
    # Get your mail template dynamically
    template_name newsletter.type.template
  end
end
```

## Licence

It uses MIT Licence so you can do whatever you want with it

