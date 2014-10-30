sudo rm /var/spool/mail/ec2-user
if grep -q "Test failed" test.jtl; then
  mail -s 'at least one test failed' xu_cao@spe.sony.com <msg.txt
fi
