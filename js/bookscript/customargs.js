import {markdownTable} from "markdown-table";
import {marked} from "marked";

import prompt from "prompt";

prompt.start();

prompt.get(["title", "author", "date"], function (err, result) {
    if (err) { return onErr(err); }


    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var myObj = {
      "title": result.title,
      "author": result.author,
      "date": ""
    };


    if (result.date) {
      const d = new Date(result.date);
      myObj.date = `${months[d.getMonth()]} ${d.getDate()}`;

    } else {
      const d = new Date();
      myObj.date = `${months[d.getMonth()]} ${d.getDate()}`;
    }


    // > markdown table
    let mdOutput = markdownTable([
      ["title", "author", "date"],
      [myObj.title, myObj.author, myObj.date]
    ]);

    const html = marked.parse(mdOutput);

    console.log(html)
    console.log(mdOutput);
});

function onErr(err) {
    console.log(err);
    return 1;
}
