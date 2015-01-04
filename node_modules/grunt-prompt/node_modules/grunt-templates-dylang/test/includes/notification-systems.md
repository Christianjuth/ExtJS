## Notifications aren't showing

Run `grunt --debug` to show `grunt-notify` debug messages. Create an issue and I'll look into it asap.

## Terminal Notifier

Apple does not provide an API to the OS X Notification Center that Node can access. Only code written in Objective C and signed in XCode can use it.
This is not very friendly for Node users so we are using the tiny signed MIT-licensed native application
[Terminal Notifier](https://github.com/alloy/terminal-notifier) from [Eloy Durán](https://github.com/alloy).
I've changed the default icon which is owned by Apple to the Grunt logo.
