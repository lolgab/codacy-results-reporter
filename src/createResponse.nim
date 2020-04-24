import model/api
import model/result
import sequtils
import strformat

func createResponse*(toolShortName: string, toolLongName: string, results: seq[ToolOutput]): ResponseBody =
  let convertedResults = results.map(
    proc (r: ToolOutput): Result =
      Result(
        Issue:
          IssueObject(
            patternId: PatternId(value: fmt"{toolLongName}_{r.patternId}"),
            filename: r.filename,
            message: Message(text: r.message),
            level: Info,
            location: Location(
              FullLocation: FullLocationObject(
                  line: r.line,
                  column: 0
                )
              )
            )
          )

  )
  ResponseBody(tool: toolShortName, issues: Response(results: convertedResults))