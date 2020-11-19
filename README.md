# amq-docker

Build a custom AMQ7 Docker image with multiple users.

1. Make sure that you do not change the AMQ_NAME template variable, if you do, make sure it matches with the one present in artemis.profile

2. New users will be configured using the template variable ARTEMIS_AUTH and it's values will be the : (colon) separated username:password:role
 
  `ARTEMIS_AUTH=username:password:readonly`

  If you want to configure more than 1 user then add the next set of property after a comma (,):

  `ARTEMIS_AUTH=username:password:readonly,test:testpassword:testrole`

3. Make sure that the roles defined in ARTEMIS_AUTH variable are present in management.xm for suitable operations and in the artemis.profile for -Dhawtio.role option.

4. Clone this repo and run:

  `docker build /cloned_dir --tag amq_custom`

5. To test the latest build.

   `docker run -it -e AMQ_USER=admin -e AMQ_PASSWORD=admin -e ARTEMIS_AUTH=user:password:readonly amq_custom`


