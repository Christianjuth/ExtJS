//initilize Parse and import dependencies
var Parse = require('parse').Parse;
Parse.initialize("kZS90MpRoWUMtFEgdt8kdWSejhl3thUb9GPdekpb", "ND73SsKVmvrxJ04LmLNgN2lqulJqdjqfRkvI6n23");
var exec = require('child_process').exec

//vars
var search = process.argv.splice(2)[0]
var path = 'app/ext-plugins/'
var Plugin = Parse.Object.extend("Plugin");

//query database
var query = new Parse.Query(Plugin);
query.equalTo("search", search.toLowerCase());
query.notEqualTo("file", null)

//results
query.first({
  success: function(plug) {

    //check if plugin exists
    if(typeof plug === "undefined"){
      console.log("Plugin not found.")
      return;
    }

    //download plugin
    url = plug.get('file').url()
    exec('curl -o '+path+search+'.js '+url)
    console.log(path+search+'.js')
    return;

  }
});
