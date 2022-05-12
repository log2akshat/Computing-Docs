#/usr/bin/python

import os

os.environ['PYTHON_EGG_CACHE'] = '/usr/local/trac/ComputingDocs/eggs'

import trac.web.main
def application(environ, start_response):
  environ['trac.env_path'] = '/usr/local/trac/ComputingDocs' 
  return trac.web.main.dispatch_request(environ, start_response)
