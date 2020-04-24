from result import Level

type PatternId* = object
  value*: string

type Message* = object
  text*: string

type FullLocationObject* = object
  line*: int
  column*: int

type Location* = object
  FullLocation*: FullLocationObject

type IssueObject* = object
  patternId*: PatternId
  filename*: string
  message*: Message
  level*: Level
  location*: Location

type Result* = object
  Issue*: IssueObject

type Success = object
  results*: seq[Result]

type Response* = Success # | Failure

type
  ResponseBody* = object
    tool*: string
    issues*: Response
