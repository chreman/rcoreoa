core_base <- function() "https://core.ac.uk"

cp <- function(x) Filter(Negate(is.null), x)

core_GET <- function(path, key, args, ...){
  cli <- crul::HttpClient$new(
    url = core_base(),
    headers = list(apiKey = check_key(key))
  )
  temp <- cli$get(
    path = file.path("api-v2", path),
    query = cp(args),
    ...
  )
  temp$raise_for_status()
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  temp$parse("UTF-8")
}

core_POST <- function(path, key, args, body, ...){
  cli <- crul::HttpClient$new(
    url = core_base(),
    headers = list(apiKey = check_key(key))
  )
  temp <- cli$post(
    path = file.path("api-v2", path),
    query = cp(args),
    body = jsonlite::toJSON(body, auto_unbox = TRUE), encode = "json", ...
  )
  temp$raise_for_status()
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  temp$parse("UTF-8")
}

core_GET_disk <- function(path, id, key, overwrite, ...){
  core_cache$mkdir()
  fpath <- file.path(core_cache$cache_path_get(), paste0(id, ".pdf"))
  if (!overwrite) {
    pdftry <- tryCatch(suppressMessages(pdftools::pdf_info(fpath)),
      error = function(e) e)
    if (file.exists(fpath) && !inherits(pdftry, "error")) {
      return(fpath)
    }
  }

  cli <- crul::HttpClient$new(
    url = core_base(),
    headers = list(apiKey = check_key(key))
  )
  temp <- cli$get(path = file.path("api-v2", path), disk = fpath, ...)
  # unlink/delete file if http error code
  if (temp$status_code > 201) unlink(fpath)
  temp$raise_for_status()
  temp$content
}

core_parse <- function(x, parse) {
  jsonlite::fromJSON(x, parse)
}

check_key <- function(x){
  tmp <- if (is.null(x)) Sys.getenv("CORE_KEY", "") else x
  if (tmp == "") {
    getOption("core_key", stop("you need an API key for Core", call. = FALSE))
  } else {
    tmp
  }
}

must_be <- function(x, y = 10) {
  if (x < y) stop("limit must be >= 10", call. = FALSE)
}

clog <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    if (x) 'true' else 'false'
  }
}

pdf_parse <- function(x) pdftools::pdf_text(x)

create_batch_query_list <- function(queries, page, pageSize) {
  queryList <- lapply(queries, function(x){
    as.list(stats::setNames(x, rep("query", length(x))))
  })

  queryList <- Map(c, queryList, page = rep(page))
  queryList <- Map(c, queryList, pageSize = rep(pageSize))

  return(queryList)
}

asl <- function(z) {
  if (is.null(z)) return(NULL)
  if (is.logical(z) || tolower(z) == "true" || tolower(z) == "false") {
    if (z) {
      return('true')
    } else {
      return('false')
    }
  } else {
    return(z)
  }
}
