import httpClient
import json
import model
import sequtils
import strformat
import cligen

proc readAllResults(): seq[ToolOutput] =
  iterator readInput(): ToolOutput =
    var over = false
    while not over:
      try:
        let line = readLine(stdin)
        let json = parseJson(line)
        yield json.to(ToolOutput)
      except EOFError:
        over = true
  readInput.toSeq()

proc main(shortName: string, longName: string, commit: string, projectToken: string): int=
  let results = readAllResults()

  let response: ResponseBody = createResponse(toolShortName = shortName, toolLongName = longName, results = results)

  let jsonResponse = `%`(response)
  echo(jsonResponse.pretty())
  let stringResponse = `$`(jsonResponse)

  let client = newHttpClient()
  client.headers = newHttpHeaders(
    { "Content-Type": "application/json", "project-token": projectToken }
  )

  discard client.request(fmt"https://api.codacy.com/2.0/commit/{commit}/issuesRemoteResults", httpMethod = HttpPost, body = stringResponse)
  
  discard client.request(fmt"https://api.codacy.com/2.0/commit/{commit}/resultsFinal", httpMethod = HttpPost)

  result = 1

dispatch(main, cmdName = "codacy-results-reporter")
