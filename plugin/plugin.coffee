#this code is exposed to the user
plugin = {

  _info :
    authors : ['Your Name']
    name : 'Hello World'
    version : '0.1.0'
    min : '0.1.0'
    compatibility :
      chrome : 'full'
      safari : 'full'

  _aliases : ['hello']

  create : (msg) ->
    #vars
    if msg?
      this.msg = msg
    else
      this.msg = 'hello world!'
    #functions
    this.alert = hiddenCode.alert
    this.log   = hiddenCode.log
    this.info  = hiddenCode.info
    this.warn  = hiddenCode.warn
    this.error = hiddenCode.error
    #return
    return this

}



#this code is hidden from the user
hiddenCode = {

  alert : ->
    msg = this.msg
    alert msg
    return msg

  log : ->
    msg = this.msg
    console.log msg
    return msg

  info : ->
    msg = this.msg
    console.info msg
    return msg

  warn : ->
    msg = this.msg
    console.warn msg
    return msg

  error : ->
    msg = this.msg
    console.error msg
    return msg

}
