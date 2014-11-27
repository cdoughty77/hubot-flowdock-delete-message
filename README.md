# Hubot: flowdock-delete-message

Deletes content of the last n messages posted by hubot on flowdock.  Why
you might ask?  Because sometimes hubot goes rogue.

## Installation

Add **hubot-flowdock-delete-message** to your `package.json` file:

Tested with the following dependencies:
```json
"dependencies": {
  "hubot": ">= 2.9.3",
  "hubot-scripts": ">= 2.5.16",
  "hubot-flowdock": ">=0.7.2",
  "hubot-flowdock-delete-message": ">=0.0.0",
}
```

Add **hubot-flowdock-delete-message** to your `external-scripts.json`:

```json
["hubot-flowdock-delete-message"]
```

Run `npm install hubot-flowdock-delete-message`

## Help:

hubot delete <#> - Number of most recent hubot messages to delete
hubot abandon ship <#> - Number of most recent hubot messages to delete

## Example usage:

Delete the content of the last message posted by hubot on flowdock:
```
user> hubot delete
```

Delete the content of the last 10 messages posted by hubot on flowdock:
```
user> hubot delete 10
```
