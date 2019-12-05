#!/bin/bash

git clone git@github.com:vakabus/mff-unixadmin.git
cd mff-unixadmin
NO_CACHE=true make -j32
make deploy
