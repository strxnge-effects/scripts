#!/usr/bin/env node
import config from "./config.json" with { type: "json" };
import jsdom from "jsdom";
import {
  QMainWindow,
  QWidget,
  QLabel,
  QLineEdit,
  QPushButton,
  QMessageBox,
  QBoxLayout,
  ButtonRole,
  Direction
} from "@nodegui/nodegui";
import prompt from "prompt";
import tumblr from "tumblr.js";

const win = new QMainWindow();
win.setWindowTitle("autoqueue gui");
win.setFixedSize(400, 260);

// > root layout
const centralWidget = new QWidget();
const rootLayout = new QBoxLayout(Direction.TopToBottom);
centralWidget.setObjectName("myroot");
centralWidget.setLayout(rootLayout);

// >> source
const labelSource = new QLabel();
labelSource.setObjectName("labelSource");
labelSource.setText("source:");

const lineSource = new QLineEdit();
lineSource.setObjectName("lineSource");

// >> image url
const labelImageUrl = new QLabel();
labelImageUrl.setObjectName("labelImageUrl");
labelImageUrl.setText("image url:");

const lineImageUrl = new QLineEdit();
lineImageUrl.setObjectName("lineImageUrl");

// >> author
const labelAuthor = new QLabel();
labelAuthor.setObjectName("labelAuthor");
labelAuthor.setText("author:");

const lineAuthor = new QLineEdit();
lineAuthor.setObjectName("lineAuthor");

// >> tags
const labelTags = new QLabel();
labelTags.setObjectName("labelTags");
labelTags.setText("tags:");

const lineTags = new QLineEdit();
lineTags.setObjectName("lineTags");
lineTags.setText("art, utau, ");

// >> submit
const buttonSubmit = new QPushButton();
buttonSubmit.setObjectName("buttonSubmit");
buttonSubmit.setText("submit");

// >> messagebox
const messageBox = new QMessageBox();
const buttonAccept = new QPushButton();
buttonAccept.setText("ok")
messageBox.addButton(buttonAccept, ButtonRole.AcceptRole);

rootLayout.addWidget(labelSource);
rootLayout.addWidget(lineSource);
rootLayout.addWidget(labelImageUrl);
rootLayout.addWidget(lineImageUrl);
rootLayout.addWidget(labelAuthor);
rootLayout.addWidget(lineAuthor);
rootLayout.addWidget(labelTags);
rootLayout.addWidget(lineTags);
rootLayout.addWidget(buttonSubmit);
win.setCentralWidget(centralWidget);

// > logic
// authenticate using info found in ./config.json
const client = tumblr.createClient({
  consumer_key: config.consumer_key,
  consumer_secret: config.consumer_secret,
  token: config.token,
  token_secret: config.token_secret
});

async function getQueue() {
  let response = await client.blogQueue(`${config.blog_id}.tumblr.com`,
    { offset: -20 });
  // request last 20 queued posts from blog

  for (let obj of response.posts.reverse()) {
  // check date of last scheduled post
    let date = new Date();
    date.setDate(date.getDate() + 1);
    // publish_on defaults to tomorrow at the same time

    if (obj.queued_state == "scheduled") {
      // if found, schedule new post for 1 day after latest scheduled post
      let date = new Date(obj.publish_on);
      date.setDate(date.getDate() + 1);

      return(date);
    }
  }
}

async function getPixivAuthor(pixivAuthorPage) {
  // fetch author name from pixiv url
  let author = fetch(pixivAuthorPage)
    .then(response => response.text())
    .then(html => {
      let doc = new jsdom.JSDOM(html);
      let title = doc.window.document.querySelector("title");
      let author = title.textContent.split(" - ")[0];
      return(author);
    });

  return(author);
}

async function generatePostContents(result, author, date) {
  try {
    await client.createPost(config.blog_id, {
      content: [
        {
          type: "image",
          media: {
            "url": result.image_url,
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
              "url": result.author
            }
          ]
        }
      ],
      publish_on: date,
      source_url: result.source,
      state: "queued",
      tags: [
        "art", "utau", result.tags
      ]
    });

    messageBox.setText(`scheduled on ${config.blog_id} at ${date}`);
  } catch (error) {
    console.error(error);
    messageBox.setText(error.toString());
  } finally {
    messageBox.exec();
  }
}

// > event handling
buttonSubmit.addEventListener("clicked", () => {
  try {
      (async () => {
        let result = {
          "source": lineSource.text(),
          "image_url": lineImageUrl.text(),
          "author": lineAuthor.text(),
          "tags": lineTags.text()
        };
        let author = await getPixivAuthor(result.author);
        let date = await getQueue();
  
        generatePostContents(result, author, date);
    })(); 
  } catch (error) {
    console.error(error);
    messageBox.setText(error.toString());
    messageBox.exec();
  } finally {
    // prevent multiple requests at the same time
    buttonSubmit.setDisabled(true);
  }
});

buttonAccept.addEventListener("clicked", () => {
  buttonSubmit.setEnabled(true);
});

win.show();

global.win = win;
