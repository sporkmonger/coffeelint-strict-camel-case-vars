regexes =
  camelCase : /^_?_?[a-zA-Z][a-zA-Z\d]*$/
  allCaps : /^_?_?[A-Z][_A-Z\d]*$/

module.exports = class CamelCaseVars
  rule:
    name: 'camel_case_vars'
    level : 'error'
    message : 'Variable and property names should be camelCased'
    description: """
      This rule mandates that all variable and property names are either
      camelCased or ALL_CAPS.
      <pre>
      <code># Good!
      myVar = 23

      # Good!
      MY_CONSTANT = 23

      # Bad!
      my_var = 23
      </code>
      </pre>
      """

  tokens: ['IDENTIFIER']

  lintToken: (token, tokenApi) ->
    # It's common to reference a variable as an object property, e.g.
    # MyClass.myVarName, so loop through the next tokens until
    # we find the real identifier
    varName = null
    offset = 0
    while not varName?
      if tokenApi.peek(offset + 1)?[0] is '.'
        offset += 2
      else if tokenApi.peek(offset)?[0] is '@'
        offset += 1
      else
        varName = tokenApi.peek(offset)[1]

    # Now check for the error
    if not regexes.camelCase.test(varName) and not regexes.allCaps.test(varName)
      return {context: "var name: #{varName}"}
