# PureAdventure

PureScript FFI bindings and bot

## Adventure Land

Adventure Land is a game available on Steam in which
you program using JavaScript. Of course, because I 
hate JavaScript, I decided to give PureScript a go.
This is my adventure (land).

## Building

It's quite complicatated to get set up, but overall
there's 1 magic command.

```bash
pulp build --optimise > out.js
```

After this, a file called `out.js` should be
available, this will allow you to run your bot in
Adventure Land through the code editor.

Here's how you can get it to load automatically:
```js
const STARTUP = '{YOUR PATH HERE}'; // Path of PS gen file
const fs = require('fs');
const reload = () => {
	game_log("File change detected");
	const data = fs.readFileSync(STARTUP, 'utf8');
	// This is necessary to kill all timers that PureScript might be running
	const killId = setTimeout(function() {
	  for (let i = killId; i > 0; i--) clearInterval(i)
	}, 3000);
	eval.apply( window, [data] );	
};
reload();
fs.watch(STARTUP, () => {
	reload();
});
```
