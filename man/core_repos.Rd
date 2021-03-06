% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/core_repos.R
\name{core_repos}
\alias{core_repos}
\title{Get repositories via their repository IDs}
\usage{
core_repos(id, key = NULL, method = "GET", parse = TRUE, ...)
}
\arguments{
\item{id}{(integer) One or more repository IDs. Required}

\item{key}{A CORE API key. Get one at
\url{https://core.ac.uk/api-keys/register}. Once you have the key,
you can pass it into this parameter, or as a much better option,
store your key as an environment variable with the name
\code{CORE_KEY} or an R option as \code{core_key}. See \code{?Startup}
for how to work with env vars and R options}

\item{method}{(character) one of 'GET' (default) or 'POST'}

\item{parse}{(logical) Whether to parse to list (\code{FALSE}) or
data.frame (\code{TRUE}). Default: \code{TRUE}}

\item{...}{Curl options passed to \code{\link[crul]{HttpClient}}}
}
\description{
Get repositories via their repository IDs
}
\details{
\code{core_repos} does the HTTP request and parses, while
\code{core_repos_} just does the HTTP request, gives back JSON as a
character string

These functions take one article ID at a time. Use lapply/loops/etc for
many ids
}
\examples{
\dontrun{
core_repos(id = 507)
core_repos(id = 444)

ids <- c(507, 444, 70)
res <- lapply(ids, core_repos)
vapply(res, "[[", "", c("data", "name"))

# just http request, get json as character vector back
core_repos_(507)
}
}
\references{
\url{https://core.ac.uk/docs/#!/repositories/getRepositoryById}
\url{https://core.ac.uk/docs/#!/repositories/getRepositoryByIdBatch}
}
