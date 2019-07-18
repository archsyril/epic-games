template err*(failed: string): untyped=
  echo "Failed to initialize "&failed&". Error: ", getError()
  return false

template kill*(ut: untyped): untyped=
  ut.destroy(); ut= nil