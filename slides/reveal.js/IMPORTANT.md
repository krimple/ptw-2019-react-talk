Problems with hash reloading and the history API caused us to load the developer version of reveal.js on 5/23/2018. This is in ./js/reveal.js and I've nuked the reveal.min.js file.

However, live reload is not yet working. At least you can refresh the page manually to get your updated HTML. Until reveal.js has another production release (which is long overdue) we can't fix this any other way.

Or maybe there's a way to fix livereload but that probably involves a hot patch.

Ken Rimple
5/23/2018
