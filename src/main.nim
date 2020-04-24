import sequtils
import json
import model/result
import model/api
import createResponse
import httpClient
import strformat
import os

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


let projectTokenEnvName = "PROJECT_TOKEN"
let projectToken: string = getEnv(projectTokenEnvName)
assert(projectToken != "", fmt"{projectTokenEnvName} is not defined!")

let commitEnvName = "COMMIT"
let commit: string = getEnv(commitEnvName)
assert(commit != "", fmt"{commitEnvName} is not defined!")

let results = readAllResults()

let response: ResponseBody = createResponse(toolShortName = "clang-tidy", toolLongName = "ClangTidy", results = results)

let jsonResponse = `%`(response)
let stringResponse = jsonResponse.to(string)
echo(jsonResponse)

let client = newHttpClient()
client.headers = newHttpHeaders(
  { "Content-Type": "application/json", "project-token": projectToken}
)

discard client.request(fmt"https://api.codacy.com/2.0/commit/{commit}/issuesRemoteResults", httpMethod = HttpPost, body = stringResponse)
discard client.request(fmt"https://api.codacy.com/2.0/commit/{commit}/resultsFinal", httpMethod = HttpPost)
