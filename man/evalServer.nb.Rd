\name{evalServer.nb}
\alias{evalServer.nb}
\title{Non-blocking Socket Server evaluation}
\usage{
  evalServer.nb(con, expr, blocking = TRUE)
}
\arguments{
  \item{con}{A connection}
}
\value{
  If blocking is FALSE it always returns the string
  '___non-blocking___' otherwise it will return whatever
  was evaluated
}
\description{
  This allows a non-blocking evaluation of code on the
  server
}

