// Use for getting chars on your keyboard (including backspace, ctrl and so on...)

let stdin = process.stdin;
stdin.setEncoding("utf8");
stdin.setRawMode(true);

stdin.on("data", chunk => {
  console.log(JSON.stringify(chunk))
});
