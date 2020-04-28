import osproc
import strutils

proc currentCommit*(): string =
  execProcess(command = "git", args = @["rev-parse", "HEAD"], options={poUsePath}).strip