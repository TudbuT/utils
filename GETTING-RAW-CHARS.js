// Use for getting chars on your keyboard (including backspace, ctrl and so on...) If the char is not existing in unicode, it will escape the char.

let stdin = process.stdin; // Aliasing proces.stdin.
stdin.setEncoding("utf8"); // You don't want binary buffers - Do you?
stdin.setRawMode(true); // Backspace and so on are getting read too.

stdin.on("data", chunk => { // Called when any key is pressed.
  console.log(JSON.stringify(chunk)) // Logging an escaped version of the typed char.
});
