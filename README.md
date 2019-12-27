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

### Building for Playing in a Web Browser

A web server to serve the generated `out.js` file will be needed,
since web browsers do not support the filesystem API; a web-server
supporting [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
is needed, and `htpp-server` from npm is included in
the dev dependencies for this purpose.


```bash
mkdir out
npx http-server ./out --cors -p 8000 &

pulp build --optimise > out/out.js
```

Note that you will need to re-engage code from the UI to load
an updated `out.js` file, as there is no watching of the `out.js`
file in this scenario.

You can then use the following code snippet in Adventure Land
to load the served code should be:

```js
const CODE_URL = 'http://localhost:8000/out.js';
// Path of PS gen file

const reload = async () => {
	const ms = Date.now();
  const data = await fetch(CODE_URL+"?dummy="+ms)
	  .catch(er => game_log(er.message))
    .then(response => response.text());
	game_log("Retrieved out.js");
	// This is necessary to kill all timers that PureScript might be running
	const killId = setTimeout(function() {
	  for (let i = killId; i > 0; i--) clearInterval(i)
	}, 3000);
	eval.apply( window, [data] );
};
reload();
```

### Running on  NixOS

A convenient option is to use [easy-purescript-nix](https://github.com/justinwoo/easy-purescript-nix):


```
# Do the following each time starting the environment:
cd /path/to/easy-purescript-nix
nix-shell ci.nix
cd /path/to/PureAdventure

npm install # run once
npx bower install # run once

pulp build --optimise > out.js

```


