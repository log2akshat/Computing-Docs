#    Copyright (C) <2022>  <Akshat Singh>
#    <akshat-pg8@iiitmk.ac.in>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#    This is a Config file for trac to run on apache webserver

#/usr/bin/python

import os

os.environ['PYTHON_EGG_CACHE'] = '/usr/local/trac/ComputingDocs/eggs'

import trac.web.main
def application(environ, start_response):
  environ['trac.env_path'] = '/usr/local/trac/ComputingDocs' 
  return trac.web.main.dispatch_request(environ, start_response)
