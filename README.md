## Introduction

This is a custom version of the [hubot-deploy](https://github.com/atmos/hubot-deploy) [Hubot](https://hubot.github.com) script. It retains all the functionality of the original version, but includes some new features that one of my projects required at a time. Feel free to use it too, if you also need this specific features. Else, visit the original script page.

## New features

* [Optional] Persist its deployable apps data in a Redis instance.
* [Optional] Expose a REST-like API for apps data.

## How to enable optional features

In order for optional features to work, you must set some environment variables with useful information that these features need.

If you want to activate the deployable apps data persistance, you need to set the environment variable `REDISTOGO_URL` with the location of the Redis instance to persist in. That URL has to be like this:

`redis://redistogo:bf97fg52408700451ff120124b4861ec@hoki.redistogo.com:9241/`.

If you deploy your Hubot project to Heroku and add the Redis To Go addon, then you have this variable already set. Also, you'll have to set `HUBOT_DEPLOY_REST_APPS` to `true`.

If you set `HUBOT_DEPLOY_REST_APPS` to `true`, then the REST API for deployable apps data is, by default, activated. This will provide your bot with web endpoints that other apps/services can use to retrieve data about what can your bot deploy and to teach your bot how to deploy new apps.

Routes are like these:

    |-------------------------|-------------------------------------|----------------------------------------|
    | Route                   | Action                              | Response                               |
    |-------------------------|-------------------------------------|----------------------------------------|
    | GET /deploy/apps        | List all apps your bot knows how to | A JSON response with an `apps` object  |
    |                         | deploy.                             | that has the same format than the      |
    |                         |                                     | original apps.json.                    | 
    |-------------------------|-------------------------------------|----------------------------------------|
    | GET /deploy/apps/:id    | Get a single app's data.            | A JSON response with the app's data.   |
    |-------------------------|-------------------------------------|----------------------------------------|
    | POST /deploy/apps       | Add a new app to your bot's         | 201 Created.                           | 
    |                         | deployable apps. You must send an   |                                        |
    |                         | `app` JSON object, with the same    |                                        |
    |                         | format as apps in the original      |                                        |
    |                         | apps.json and a `name` atribute.    |                                        |
    |-------------------------|-------------------------------------|----------------------------------------|
    | PATCH /deploy/apps/:id  | Replaces app's data with given data.| 204 No Content                         |
    |                         | New data is given as JSON object.   |                                        |
    |-------------------------|-------------------------------------|----------------------------------------|
    | DELETE /deploy/apps/:id | Delete an app given its id.         | 204 No Content                         |
    | ------------------------|-------------------------------------|----------------------------------------|

## Notices

This is part of my internship project at [Crowd Interactive](http://crowdint.com).
