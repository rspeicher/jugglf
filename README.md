# JuggLF

JuggLF is a Rails application written to replace the aging, hacked-up [EQdkp](http://eqdkp.com) installation for my guild, [Juggernaut](http://www.juggernautguild.com). It tracks member attendance and loot history, and lets members build wishlists -- a priority list of loot they need -- which are a central part of our guild organization.

## Features

- Full member attendance and loot history tracking
- Wishlists with multiple priorities
- Achievement tracking
- A punishment system that can be used to adjust a member's loot factor, with variable expiration dates
- Interesting stats and history on the index page for a long-running guild
- Live attendance and loot tracking for a raid night (to use instead of or as a compliment to an in-game addon)

## Customizing For Your Guild

As the application was written specifically and solely for Juggernaut's use, you'll have to make several major changes to it if you want to use it for your own guild, even if you copy our loot system exactly.

### Layout

The default application layout uses the skin from our forum in order to fit in with the overall look of our site. You probably want to use your own.

### Login

The application uses a gem I wrote specifically for it called [invision_bridge](http://github.com/tsigo/invision_bridge), which lets Authlogic access an [IP.Board](http://www.invisionpower.com) database and allows users to only have one login for the entire site. I'd recommend either fully implementing the rest of an authentication system with Authlogic (sign up, user management, etc.) and making users maintain two separate accounts, or writing a similar gem for your own forum system.

### Item Prices

In most cases, we determine the price of a loot based on the item's level and slot. Sometimes this varies by member class. For example a one-handed weapon is less valuable for a Hunter than a Rogue, and vice-versa for a ranged weapon. Trinkets are priced on a case-by-case basis, since not all trinkets are equally useful, or desired.

Item prices are currently determined by the ItemPrice model. Unfortunately this file is a bit of a mess. I'd love to provide a web interface for customizing these values, but right now it's a case of too much work for not enough reward.

### Wishlist Data

Maybe you don't raid the same zones we do. You probably want to change the Wishlists page to show zones and bosses you care about.

Zone > Boss > Item data is currently populated by the `lib/tasks/wishlist.rake` file which is a _hot mess_. This is another area where I want to turn it into a web interface, but again, too much work, not enough reward for the time being. See the `lib/scraper.rb` file for an example of scraping loot data for a boss from the Armory. Seriously. Hot mess.

### Attendance Parsing

Adding a raid involves copying and pasting the attendance and loot which gets posted to our forum in a very specific format by this application. We track a raid night inside the application, and then that data gets posted to our forum over XMLRPC in order to let users bring up any errors ("I never got to loot [This Item], please mark it as DE").

The data from the thread is then copied and pasted into JuggLF which gets us Raid and Loot data.

## History and Background

This was the first Rails application I wrote, and the first that I'm releasing. I ran `rails .` on December 11, 2008. Over time I've refined it as I learned, and plan to continue doing so for as long as is necessary. It's not perfect. I'm sure there are spots where I'm doing things sub-optimally or even completely wrong. Feel free to point them out to me.

## Contributing

I'd love to see what other people do with this. Please fork and/or submit tickets!

## Credits

Copyright (c) 2008-2010 Robert Speicher, released under the MIT license