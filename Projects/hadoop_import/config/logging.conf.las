[loggers]
keys=root,bin,hadoopimport

[handlers]
keys=stdoutHandler,stderrHandler

[formatters]
keys=simpleFormatter

[logger_root]
level=INFO
handlers=stderrHandler

[logger_bin]
level=INFO
handlers=stdoutHandler
qualname=bin
propagate=0

[logger_hadoopimport]
level=INFO
handlers=stdoutHandler
qualname=hadoopimport
propagate=0

[handler_stdoutHandler]
level=INFO
class=StreamHandler
formatter=simpleFormatter
args=(sys.stdout,)

[handler_stderrHandler]
level=INFO
class=StreamHandler
formatter=simpleFormatter
args=(sys.stderr,)

[formatter_simpleFormatter]
format=%(asctime)s - %(levelname)s - %(module)s:%(lineno)s - %(funcName)s - %(message)s
datefmt=
