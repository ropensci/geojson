library("devtools")

res <- revdep_check()
revdep_check_save_summary()
revdep_check_print_problems()
#revdep_email(date = "Dec 24", version = "v0.2.0", only_problems = FALSE, draft = TRUE)
