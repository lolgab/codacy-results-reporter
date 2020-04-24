# sealed trait Result
import options

type 
  Level* = enum
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
    patternId*: string
    filename*: string
    message*: string
    line*: int
