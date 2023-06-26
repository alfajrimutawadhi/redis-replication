class Resp
  # ref: https://redis.io/docs/reference/protocol-spec/#resp-protocol-description
  SIMPLE_STRINGS = "+"
  ERRORS = "-"
  INTEGERS = ":"
  BULK_STRINGS = "$"
  ARRAYS = "*"
end