# ffmpeg on Ice!

![ffmpeg logo in an ice rink](public/images/ffmpegOnIce.png)

**What?**

Look, buddy, I don't know. I wanted to play with Rails in my last couple weeks at the [Recurse Center](https://recurse.com) and draw more attention to the extremely cool [ffmpeg-artschool](https://amiaopensource.github.io/ffmpeg-artschool/) project; this demonstrates a few of the transforms that they provide examples for, using any of your own videos, with Ruby's *carrierwave* interface to `ffmpeg`. "On Ice" kind of calls to mind "On Rails," and ffmpeg does a little performance for you in the browser, and ...

**Please explain the joke more**

OK, fine, anyway, it lives at [https://ffmpeg-on-ice.herokuapp.com/](https://ffmpeg-on-ice.herokuapp.com/). I do a lot of my own cowboy deployments lately for various reasons (server sovereignty, free academic resources, years of running desktop Linux...) and using Rails also seemed like a good excuse to use Heroku. Plus, this thing actually hits the CPU pretty hard when it processes video, and Heroku's limited compute hours and [transient storage](https://devcenter.heroku.com/articles/active-storage-on-heroku) were just the ticket for a project that needs a real backend but doesn't do anything persistent. Heroku's free tier memory limits, on the other hand, were rather less helpful... no promises it'll stay up.

Used [this](https://www.randygirard.com/how-to-create-a-video-upload-platform-using-ruby-on-rails-part-1/) as a very helpful starting point.


# Running for development

```
bundle install
rake db:create
rake db:migrate
```

Optionally, depending on platform (try it without; Windows msys hates this but webpacker might be unhappy without it):

```
rails webpacker:install
bundle exec rake assets:precompile
```

And run with `rails s`