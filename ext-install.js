var Parse = require('parse').Parse;
Parse.initialize("kZS90MpRoWUMtFEgdt8kdWSejhl3thUb9GPdekpb", "ND73SsKVmvrxJ04LmLNgN2lqulJqdjqfRkvI6n23");
var exec = require('child_process').exec

search = process.argv.splice(2)[0]
path = 'app/ext-plugins/'

var Plugin = Parse.Object.extend("Plugin");
var query = new Parse.Query(Plugin);
query.equalTo("search", search.toLowerCase());
query.notEqualTo("name","")
query.notEqualTo("file", null)

query.first({
  success: function(plug) {

    if(typeof plug === "undefined"){
      console.log("Plugin not found.")
      return;
    }

    url = plug.get('file').url()
    exec('curl -o '+path+search+'.js '+url)

    return;

  }
});
