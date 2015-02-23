var Parse = require('parse').Parse;
Parse.initialize("kZS90MpRoWUMtFEgdt8kdWSejhl3thUb9GPdekpb", "ND73SsKVmvrxJ04LmLNgN2lqulJqdjqfRkvI6n23");
var prompt = require('prompt');
var fs = require('fs');

var Plugin = Parse.Object.extend("Plugin");
var schema = {
  properties: {
    password: {
      hidden: true
    }
  }
};

prompt.start();
prompt.get(schema, function (err, result) {

  Parse.User.logIn('extjs', result.password, {
    success: function(){
      login();
    },
    error: function(user, err){
      console.log(err.message);
      return;
    }
  })

});

login = function(){

  plugins = process.argv.splice(2)

  for(i=0; i<plugins.length; i++){
    plugin = plugins[0]

    var query = new Parse.Query(Plugin);
    query.equalTo("search", plugin.toLowerCase());
    query.first({
      success: function(plug) {

        if(typeof plug === "undefined"){
          console.log("Plugin not found.")
          return;
        }

        //get file
        fs.readFile('dist/plugins/'+plugin+'/readme.md', 'utf8', function (err, readme) {
          fs.readFile('dist/plugins/'+plugin+'/'+plugin+'.js', function (err, pluginFile) {
            if (err) {
              return console.log(err);
            }

            //save file
            var fileName = "plugin.js"
            var parseFile = new Parse.File(fileName, {base64: pluginFile.toString('base64', 0, pluginFile.length)})
            parseFile.save({
              success: function() {
                console.log("file uploaded")
              }
            }).then(function(result) {

              //save plugin
              plug.set('file', result)
              plug.set('readme', readme)
              plug.save({
                success: function(){
                  console.log("Updated "+plug.get("name"))
                },
                error: function(user, err){
                  console.log(err.message)
                }
              })

            });
          });
        });

      }
    });

  }

}
