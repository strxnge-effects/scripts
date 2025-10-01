import prompt from "prompt";
import nodePandoc from "node-pandoc";
import format from "html-format";
import fs from "node:fs";
import "colors";

function callback(err, result) {
  if (err) console.error("ERROR:".red, err);
}

function getInput() {
  prompt.start();
  prompt.get(["path"], function (err, a) {
    convertToHTML(a.path);
  });
}

function convertToHTML(src) {
  let ext = src.split(".").at(-1);
  let output = `${src.split(".")[0]}.html`;
  let args = `-f ${ext} -t html --wrap=none --template=tno-template.html --metadata title="fcu" -o ${output}`;
  
  nodePandoc(src, args, callback);
  formatOutput(output);
}

function writeToFile(src, data) {
  console.log(format(data));
  // fs.writeFile(out, format(data), err => {
    // if (err) {
      // console.error(err);
    // }
  // });
}

function formatOutput(src) {
  fs.readFile(src, "utf8", (err, data) => {
    if (err) {
      console.error("Error reading file:", err);
      return;
    }
    writeToFile(src, data);
  });
  // console.log("write output to", output.green);
}


getInput();

