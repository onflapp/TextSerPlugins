# TextSer

[TextSer](https://onflapp.github.io/blog/pages/TextSer.html?utm_source=git) is service tool for text writers. Write Markdown in Evernote, highlight source code fragments in Outlook, turn web links into QR code.

# TextSerPlugins

Useful plugins and samples for [TextSer](https://onflapp.github.io/blog/pages/TextSer.html?utm_source=git) app.

There are two types of plugins; one that does something with frontmost app
(e.g extracts text) and the other that is used as an *action*.

This repository includes plugins you can use "out of the box" or as a starting point for creating your own plugins.

The plugins must be placed into app's "Application Scripts" folder
**~/Library/Application\ Scripts/com.onflapp.TextSer**.

## Install plugins using GIT

```
git clone https://github.com/onflapp/TextSerPlugins.git
cp -r ./TextSerPlugins/* ~/Library/Application\ Scripts/com.onflapp.TextSer
```

## Download and install zipped plugins

1. [download zip archive](https://github.com/onflapp/TextSerPlugins/archive/master.zip) and unzip it into a directory
2. open scripts folder (Go to TextSer's **Help / Scripts Folder** menu)
3. copy __contents__ of the zip archive to the scripts folder

## Create new plugin

A TextSer plugin is rather simple AppleScript file. The plugins are intended
to be changed and modified by users. Description how to [create new plugin](https://onflapp.github.io/TextSerPlugins/).

## Troubleshooting

Most of these plugins require _Accessibility_ permissions to function correctly. To enable these permissions do the following:

- open **Security and Privacy** preferences
- make sure TextSer is enabled in the **Accessibility** section

If you still have experience problems, try to remove the app and add it again.
