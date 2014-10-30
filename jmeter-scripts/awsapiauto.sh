#!/bin/bash
if test -s /var/spool/mail/ec2-user;
then
  sudo rm /var/spool/mail/ec2-user
fi
if test -s CiAPI-aws-testresults.jtl;
then
  rm CiAPI-aws-testresults.jtl
fi 
apache-jmeter-2.10/bin/jmeter -n -t Ci-API-All-Tests-AWS.jmx -l CiAPI-aws-testresults.jtl
sleep 60
if grep -q "Test failed" CiAPI-aws-testresults.jtl; then
  mail -s " At least one test failed in QA env" -a CiAPI-aws-testresults.jtl xu_cao@spe.sony.com,Art_Fort@spe.sony.com,mauro.castagnasso@huddle.com.ar < msg.txt
fi
