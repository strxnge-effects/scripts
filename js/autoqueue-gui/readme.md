# autoqueue for tumblr

automatically schedule a post to tumblr given a source url, image link, pixiv
author, and tags.

this script was specifically made to work with my sideblog
[lesbiandefoko](https://www.tumblr.com/lesbiandefoko), but can be adapted
for other uses. the parts involving the tumblr API might be useful for anyone
looking for an example.

## setting up `config.json`

create a file `config.json` in the same folder as `autoqueue.js`; this is
required to post to tumblr. your key and token can be found after [registering
an app with the tumblr API](https://www.tumblr.com/oauth/apps).

template:

```json
{ 
  "blog_id": "",
  "consumer_key": "",
  "consumer_secret": "",
  "token": "",
  "token_secret": ""
}
```
