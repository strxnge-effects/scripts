#!/usr/bin/env node
import config from "./config.json" with { type: "json"; };
import jsdom from "jsdom";
import prompt from "prompt";
import tumblr from "tumblr.js";


// authenticate using info found in ./config.json
const client = tumblr.createClient({
  consumer_key: config["consumer_key"],
  consumer_secret: config["consumer_secret"],
  token: config["token"],
  token_secret: config["token_secret"]
});


prompt.start();
prompt.get(["pixiv source", "image url", "author", "tags"], function (err, result) {
  if (err) { return onErr(err); }

  (async () => {
    let author = await getPixivAuthor(result["author"]) 
    let date = await getQueue()

    generatePostContents(result, author, date);
  })();
})


async function getQueue() {
  let response = await client.blogQueue(`${config["blog_id"]}.tumblr.com`, { offset: -20 });
  // request last 20 queued posts from blog

  for (let obj of response["posts"].reverse()) { // check date of last scheduled post
    let date = new Date();
    date.setDate(date.getDate() + 1); // publish_on defaults to tomorrow at the same time

    if (obj["queued_state"] == "scheduled") {
      // if found, schedule new post for 1 day after latest scheduled post
      let date = new Date(obj["publish_on"])
      date.setDate(date.getDate() + 1);

      return date
    }
  }
}


async function getPixivAuthor(pixivAuthorPage) {
  // fetch author name from pixiv url
  let author = fetch(pixivAuthorPage)
    .then(response => response.text())
    .then(html => {
      let doc = new jsdom.JSDOM(html);
      let author = doc.window.document.querySelector("title").textContent.split(" - ")[0];
      return(author);
    })

  return(author);
}


async function generatePostContents(result, author, date) {
  await client.createPost(config["blog_id"], {
    content: [
      {
        type: "image",
        media: {
          "url": result["image url"],
          "type": "image"
        }
      },
      {
        type: "text",
        text: author,
        formatting: [
          {
            "start": 0,
            "end": author.length,
            "type": "link",
            "url": result["author"]
          }
        ]
      }
    ],
    source_url: result["pixiv source"],
    tags: [
      "art", "utau", result["tags"]
    ],
    state: "queued",
    publish_on: date
  });

  console.log(`scheduled on ${config["blog_id"]} at ${date}`)
}
