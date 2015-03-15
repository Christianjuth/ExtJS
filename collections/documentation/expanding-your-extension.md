#Building Your Extension

##The Breakdown
* [Icons](documentation/expanding-your-extension#icons)
* [Popup vs Action](documentation/expanding-your-extension#popup-vs-action)
* [Pages](documentation/expanding-your-extension#pages)


##Icons
_All icons must be in png format._

The _app/icon.png_ is the icon that will be displayed on the install banner, the settings panel of both browsers, and other places.  The only place it will not be displayed is on the menu bar. All manu icons are located in the `app/menu-icons/` folder.

**Default Icons**
* `app/icon.png`
* `app/menu-icons/icon-16.png`
* `app/menu-icons/icon-19.png`

When adding custom icons, you must upload a `16x16` and `19x19` version and add `-16` and `-19` to the end of the files.  This is because Chrome and Safari ask for two different sizes.  We know this is a little tedious, and we are planning on changing this in the future.

**Adding Icons**
* `app/menu-icons/your_icon_name-16.png`
* `app/menu-icons/your_icon_name-19.png`


##Popup vs Action
_The default is action._

### Popup
Add this line of code to `app/configure.json`
```json
{
  "popup" : "pages/popup/popup.html"
}
```

### Action
**Chrome**

Remove this line of code from `app/configure.json`
```json
{
  "popup" : "pages/popup/popup.html"
}
```
To define an action, use the `ext.menu.click()` function to define a callback function
**Coffeescript**
```coffeescript
#test
ext.menu.click ->
  #your code here
```
**Javascript**
```javascript
ext.menu.click(function(){
  //your code here
});
```


##Pages
Adding pages is simple.  You simply add a new folder in the `app/pages/` dir. Your file structure should look like this
```
pages
|
`-- new_page
    |
    |-- new_page.html
    |-- new_page.coffee
    `-- new_page.less
```
Linking to a page is simple.  Just add this to the page's HTML file, but replace `new_page` with your page's name.
```html
<a href="../new_page/new_page.html">new page</a>
```
