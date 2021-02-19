#!/usr/bin/env bash

get-versions -c ./packages.cfg -o alpine -t 3.10 -s ash
get-versions -c ./packages.cfg -o alpine -t 3.11 -s ash
get-versions -c ./packages.cfg -o alpine -t 3.12 -s ash
get-versions -c ./packages.cfg -o alpine -t 3.13 -s ash

get-versions -c ./packages.cfg -o amazonlinux -t 1
get-versions -c ./packages.cfg -o amazonlinux -t 2

get-versions -c ./packages.cfg -o centos -t 7
get-versions -c ./packages.cfg -o centos -t 8

get-versions -c ./packages.cfg -o debian -t stretch
get-versions -c ./packages.cfg -o debian -t stretch-slim

get-versions -c ./packages.cfg -o debian -t buster
get-versions -c ./packages.cfg -o debian -t buster-slim

get-versions -c ./packages.cfg -o debian -t bullseye
get-versions -c ./packages.cfg -o debian -t bullseye-slim

get-versions -c ./packages.cfg -o ubuntu -t 16.04
get-versions -c ./packages.cfg -o ubuntu -t 18.04
get-versions -c ./packages.cfg -o ubuntu -t 20.04

