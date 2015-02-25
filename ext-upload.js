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

fs.readFile('configure.json', 'utf8', function (err, config) {
  if (err) {
    console.log(err);
    return;
  }

  config = JSON.parse(config)

  if (config.extUsername === '' || config.extUsername == null){
    console.log('please add username in configure.json');
    return;
  }

  prompt.start();
  prompt.get(schema, function (err, result) {

    Parse.User.logIn(config.extUsername, result.password, {
      success: function(){
        login(config);
      },
      error: function(user, err){
        console.log(err.message);
        return;
      }
    })

  });

});


login = function(config){

  var query = new Parse.Query(Plugin);
  query.equalTo("search", config.name.toLowerCase());

  query.first({
    success: function(plug) {

      if(typeof plug === "undefined"){
        console.log("Please create your plugin on our website http://ext-js.org/account/plugins then update it from here.")
        return;
      }

      fs.readFile('README.md', 'utf8', function (err, readme) {
        fs.readFile('dist/'+config.name+'.js', function (err, pluginFile) {

          var fileName = config.name+".js"
          var parseFile = new Parse.File(fileName, {base64: pluginFile.toString('base64', 0, pluginFile.length)})

          parseFile.save({
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
