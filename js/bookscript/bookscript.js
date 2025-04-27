import {markdownTable} from "markdown-table";
import {marked} from "marked";


fetch("https://status.cafe/users/transneptunianobject/status.json")
  .then( r => r.json() )
  .then( r => {
    if (!r.content.length) {
      console.log("no status (how)");
    }


    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    var myObj = {
      "title": "",
      "author": "",
      "date": ""
    };

    let coolArray = r.content.split(": ")[1].split(" by ");

    myObj.title = coolArray[0];
    myObj.author = coolArray[1];

    if (process.argv[2] == "-d") {
      const d = new Date(process.argv[3]);
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
