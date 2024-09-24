#!/bin/bash

while true 
do
	echo `date +%F-----%H-%M-%S: ; dig yourdoman.com @desired_NS  +short` >> /tmp/output
	sleep 2
done
