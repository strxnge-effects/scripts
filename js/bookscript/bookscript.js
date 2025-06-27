#!/usr/bin/env node
import minimist from 'minimist';
import prompt from "prompt";
import open, {openApp, apps} from 'open';
import * as fs from 'node:fs/promises';

import {markdownTable} from "markdown-table";
import {marked} from "marked";
import {parse} from 'node-html-parser';

const argv = minimist(process.argv.slice(2));


// > functions
// >> showHelp
function showHelp() {
  const helpMessage =
`bookscript.js
=============

small script to speed up manual updates to my reading log: markdown
output for obsidian, HTML for the neocities site


arguments
---------

-c          toggle prompt for custom input
-d <value>  use given date when fetching from status.cafe
-h          show this help message
-o <value>  write to output.txt

without custom input, the script will pull the title + author from
status.cafe, and use today's date`;

  console.log(helpMessage);
}

// >> generateTables
function generateTables(input) {
  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  // create object to convert into tables
  var myObj = {
    "title": input.title,
    "author": input.author,
    "date": ""
  };

  if (input.date) {
    // use custom date
    const d = new Date(input.date);
    myObj.date = `${months[d.getMonth()]} ${d.getDate()}`;
  } else {
    // default to today's date
    const d = new Date();
    myObj.date = `${months[d.getMonth()]} ${d.getDate()}`;
  }

  // todo: if day of the month is single digit, eg Mar 1, add 0 so that it's
  // Mar 01 :)

  let mdOutput = markdownTable([
    // create markdown table
    ["title", "author", "date"],
    [myObj.title, myObj.author, myObj.date]
  ]);

  const htmlOutput = marked.parse(mdOutput); // creates wholeass table element
  const slicedHTML = `${parse(htmlOutput).getElementsByTagName("tr")[1].toString()}\n`;
  // slice html to only include relevant tr

  if (argv.o) {
    writeToFile(slicedHTML, mdOutput);
  } else {
    console.log(slicedHTML);
    console.log(mdOutput);
  }
}

// >> useCustomArgs
function useCustomArgs() {
  prompt.start();

  prompt.get(["title", "author", "date"], function (err, result) {
    if (err) { return onErr(err); }

    generateTables(result);
  }
);}

// >> fetchStatusCafe
function fetchStatusCafe() {
  fetch("https://status.cafe/users/transneptunianobject/status.json")
    .then( r => r.json() )
    .then( r => {
      if (!r.content.length) {
        console.log("could not generate tables: no status found on https://status.cafe/users/transneptunianobject");
      }

      var result = {
        "title": "",
        "author": "",
        "date": ""
      };

      let coolArray = r.content.split(": ")[1].split(" by ");
      // status format: `currently reading: ${title} by ${author}`

      result.title = coolArray[0];
      result.author = coolArray[1];

      if (argv.d) { // use custom date
        result.date = argv.d;
      }

      generateTables(result);
  });
}

// >> writeToFile
function writeToFile(htmlIn, mdIn) {
  console.log("writing to output.txt...");

  const content =
`html
====

${htmlIn}

markdown
========

${mdIn}
`;

  fs.writeFile("output.txt", content, err => {
    if (err) {
      console.error(err);
    }
  });

  console.log("opening output.txt...")
  open("output.txt"); // open in default text editor
}

// > parse arguments
if (argv.h) {
  console.log("displaying help message...");
  showHelp();
} else if (argv.c) {
  console.log("using custom arguments...");
  useCustomArgs();
} else {
  console.log("fetching data from status.cafe...");
  fetchStatusCafe();
}
