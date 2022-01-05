## Setup

```
install.packages(
  c(
    "dplyr",
    "plumber",
    "stringr",
    "magrittr"
  )
)
```

## Run

Open **main.R** and ensure that the working directory is in the same location as that file [*./api/code/api*].

Run `source('main.R')` or simply click the *Source* button if in **RStudio**

## Changing the port

The default port is `3000` and should be accessible via [http://localhost:3000](http://localhost:3000)

If you change the port, then ensure to change the **.env** file in the frontend [*./frontend/.env*]