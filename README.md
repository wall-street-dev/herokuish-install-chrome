## GitLab's autodevops `herokuish buildpack test` support for Chrome Headless Testing

### The problem

```
 15 09 2020 17:16:42.551:INFO [karma-server]: Karma v5.0.9 server started at http://0.0.0.0:9876/
 15 09 2020 17:16:42.554:INFO [launcher]: Launching browsers ChromeNoSandbox with concurrency unlimited
 15 09 2020 17:16:42.560:INFO [launcher]: Starting browser ChromeHeadless
 15 09 2020 17:16:42.562:ERROR [launcher]: No binary for ChromeHeadless browser on your platform.
   Please, set "CHROME_BIN" env variable.
```

The issue might be solved by installing the Chrome Builpack (https://github.com/heroku/heroku-buildpack-google-chrome), however, because of the lack of support for the `app.json` by herokuish  (https://github.com/gliderlabs/herokuish/issues/428) you cannot use multiple buildpacks, meaning that the following is not going to work

```
"buildpacks": [
        {
          "url": "https://github.com/heroku/heroku-buildpack-google-chrome.git"
        },
        {
          "url": "https://github.com/heroku/heroku-buildpack-nodejs.git"
        }
]
```


### The solution
- Copy the .sh script to the root of your project
- Add the following line to the `scripts` section of your `package.json`
```js
 "heroku-prebuild": "./install-chrome.sh"
```

### Why like this?
- AutoDevops ready! Works out of the box, no need to edit the `gitlab-ci.yml` file
- Uses the official buildpack for Chrome by Heroku without modifying it
- No side effects. The scripts oly runs in the TEST environment and only within herokuish
- Puppeteer not required
