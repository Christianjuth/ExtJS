#Page: options.html

#onload
require [
  "jquery",
  "underscore",
  "mustache",
  "bootstrap",

  "ext",
  "extPlugin/notification"
], ($,_,Mustache,bootstrap,ext) ->

  change = ->
    console.log('Settings saved...')

  option =
    create:(json) ->
      type = json.type.toLocaleLowerCase()
      try
        item = this.types[type](json)
      catch
        throw 'Setting type "'+json.type+'" does not exsist'
      elm = Mustache.render $("#option").html(), {
        title:json.title,
        option: item
      }
      elm = $(elm).appendTo("#settings");
      elm.find("input[type=text], textarea").keyup ->
        ext.options.set(json.key,$(this).val())
        change()
      elm.find("select").change () ->
        ext.options.set(json.key,$(this).val())
        change()
      elm.find("input[type=checkbox]").change () ->
        ext.options.set(json.key,$(this).is(':checked'))
        change()

    types:
      text : (json) ->
        elm = Mustache.render($("#text").html(), {value:ext.options.get(json.key)})

      textarea : (json) ->
        elm = Mustache.render($("#textarea").html(), {text:ext.options.get(json.key)})

      checkbox : (json) ->
        checked =  String(ext.options.get(json.key)) is "true"
        elm = Mustache.render($("#checkbox").html(), {sel:checked})

      list : (json) ->
        current = ext.options.get(json.key)
        inx = 0
        _.find(json.options, (obj, INX) ->
          if String(obj.val) is current
            inx = INX
        )
        json.options[inx].sel = true
        elm = Mustache.render $("#select").html(), {
          current:current,
          options: json.options
        }


  ext._.getConfig (data)->
    for item in data.options
      option.create(item)
