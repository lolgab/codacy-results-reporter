# sealed trait Result
import options
import sequtils
import strformat

type 
  Level = enum
    Info, Warning, Error

type 
  Category = enum
    Security, CodeStyle, ErrorProne, Performance,
    Compatibility, UnusedCode, Complexity, BestPractice,
    Comprehensibility, Duplication, Documentation

type
  Subcategory = enum
    XSS, InputValidation, FileAccess, HTTP, Cookies,
    UnexpectedBehaviour, MassAssignment, InsecureStorage,
    InsecureModulesLibraries, Visibility, CSRF, Android,
    MaliciousCode, Cryptography, CommandInjection, FirefoxOS, Auth,
    DoS, SQLInjection, Routes, Regex, SSL, Other

type
  FileError = object
    filename: string
    message: string
    level: Level
    category: Category
    subcategory: Option[Subcategory]

type 
  Issue = object
    patternId: string
    filename: string
    message: string
    level: Level

type ToolResult = Issue | FileError

type
  ToolOutput* = object
    patternId: string
    filename: string
    message: string
    line: int

type PatternId = object
  value: string

type Message = object
  text: string

type FullLocationObject = object
  line: int
  column: int

type Location = object
  FullLocation: FullLocationObject

type IssueObject = object
  patternId: PatternId
  filename: string
  message: Message
  level: Level
  location: Location

type Result = object
  Issue: IssueObject

type SuccessObject = object
  results: seq[Result]
  
type Success = object
  Success: SuccessObject

type Response = Success # | Failure

type
  ResponseBody* = object
    tool: string
    issues: Response

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
  ResponseBody(tool: toolShortName, issues: Response(Success: SuccessObject(results: convertedResults)))
