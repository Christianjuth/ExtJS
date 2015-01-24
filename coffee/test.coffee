#define local copy
test = {

  ini : ->
    errs = 0
    tests = [
      'match'
      'validate'
    ]
    #loop through tests
    for item in tests
      if !test[item]()
        console.error 'Error with ext.' + [item]
        errs=errs+1
    #return test result
    return errs


  match : ->
    valid =
      #should return true
      ext.match.url('http://google.com','*//google.*') and
      ext.match.url('http://plus.google.com','*//plus.google.*') and
      #should return false
      !ext.match.url('http://google.com','*//apple.*') and
      !ext.match.url('http://google.com','!http://**')
    #return test result
    return valid


  validate : ->
    valid =
      #should return true
      ext.validate.url('google.com') and
      ext.validate.url('http://google.com') and
      ext.validate.url('http://www.google.com') and
      #should return false
      !ext.validate.url('google') and
      !ext.validate.url('http://')
    #return test result
    return valid

}

#expose globally
window.test = test

#define amd module
if typeof window.define is 'function' && window.define.amd
  window.define 'test', ['ext'], -> window.test
