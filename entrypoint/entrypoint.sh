#!/bin/bash

echo "-*-*-*-*-  SET PERMISSIONS FOR PHP5-FPM -*-*-*-*- "
usermod -o -u 1000 www-data || true
echo " !!! SET usermod FOR PHP5-FPM DONE"
groupmod -o -g 1000 www-data || true
echo " !!! SET groupmod FOR PHP5-FPM DONE"
echo " -*-*-*-*- SET PERMISSIONS FOR PHP5-FPM DONE -*-*-*-*- "

php-fpm
