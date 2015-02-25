PLUGIN = {



_: {

#INFO
authors:   ['Christian Juth']
name:       'UUID'
aliases:   ['UUID']
version:    '0.1.0'
libMin:     '0.1.0'
background:  true
compatibility:
  chrome :  'full'
  safari :  'full'



#EVENTS
onload : (options) ->
  if !localStorage.uuid?
    ext.uuid.reset()

}



#FUNCTIONS
reset : ->
  s = []
  hexDigits = '0123456789abcdef'
  i=0
  while i <= 36
    i++
    s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
  s[14] = '4'
  s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1)
  s[9] = s[14] = s[19] = s[23] = '-'
  uuid = s.join('');
  #log reset
  log.info('UUID was reset to "'+uuid+'"')
  localStorage.uuid = uuid



get : ->
  return localStorage.uuid



}
