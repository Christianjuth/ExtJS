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

  helloWorld : ->
    alert 'hello world'
}
