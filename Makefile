# The MIT License (MIT)
# Copyright (c) 2016 Tasdik Rahman
# https://github.com/prodicus/python-makefile

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Links
# =====
# http://tasdikrahman.me
# https://twitter.com/tasdikrahman

# Heavily influenced by 
# =====================
# - https://github.com/aclark4life/python-project
# - https://github.com/jidn/python-Makefile/blob/master/Makefile

# Replace 'requirements.txt' with another filename if needed.
REQUIREMENTS := $(wildcard requirements.txt)
PROJECT = 
PYTHON_VERSION = 
SYS_PYTHON = python$(PYTHON_VERSION)

clean:
	# find . -name \*.db | xargs rm -v
	find . -name \*.pyc | xargs rm -v

flake:
	# flake8 *.py
	flake8 $(PROJECT)/*.py

pep257:
	pep257 $(PROJECT)/*.py

# http://stackoverflow.com/a/26339924
.PHONY: help
help:
	@echo "\nPlease call with one of these targets:\n"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F:\
        '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}'\
        | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs | tr ' ' '\n' | awk\
        '{print "    - "$$0}'
	@echo "\n"

install:
	ifeq ($USER, tasdik)
		# checks whether it's me. If me, uses `mkvirtualenv` instead of
		# virtualenv
		mkvirtualenv $(PROJECT) -p /usr/bin/$(SYS_PYTHON)
		pip$(PYTHON_VERSION) install -r $(REQUIREMENTS)
	else
		virtualenv -p /usr/bin/$(SYS_PYTHON) $(PROJECT)
		source venv/bin/activate
		pip$(PYTHON_VERSION) install -r $(REQUIREMENTS)
	endif

run:
	# $(SYS_PYTHON) $(PROJECT)/main.py