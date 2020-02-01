// Use for getting chars on your keyboard (including backspace, ctrl and so on...) If the char is not existing in unicode, it will escape the char.

let stdin = process.stdin; // Aliasing proces.stdin.
stdin.setEncoding("utf8"); // You don't want binary buffers - Do you?
stdin.setRawMode(true); // Backspace and so on are getting read too.

stdin.on("data", chunk => { // Called when any key is pressed.
  console.log(JSON.stringify(chunk)) // Logging an escaped version of the typed char.
});

//After using it, you can get escape sequences using an editor (if the char is exotic) or searching it here: 'http://www.amp-what.com/unicode/search/' - then selecting the U in the search bar by clicking on it. Then it will automatically give you something like U+34 or U+234 or U+1234 (Just add 0s: U+34 > U+0034, and escape it using "\u" instead of "U+")
