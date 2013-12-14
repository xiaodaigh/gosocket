\name{go.socket}
\alias{go.socket}
\title{go.socket}
\usage{
  go.socket(code,
    port = round(runif(1, min = 3000, max = 8000)))
}
\arguments{
  \item{code}{The code you want to execute in character
  string fomrat}
}
\value{
  Three componenet: 1) cluster A cluster running the socket
  server; 2) con A connection to the soncket server; 3)
  socket a port to the socket
}
\description{
  Execute a non-blocking routine on a socket-server.
}

