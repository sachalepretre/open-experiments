#!/bin/bash
# A simple script for generating a set of users, groups, sites, and memberships for testing for testing presence
# forcing a login in web browser
# http://localhost:8080/?sling:authRequestLogin=1
# create some users
curl -u admin:admin -F:name=aaron -Fpwd=aaron -FpwdConfirm=aaron http://localhost:8080/system/userManager/user.create.html
curl -u admin:admin -F:name=becky -Fpwd=becky -FpwdConfirm=becky http://localhost:8080/system/userManager/user.create.html
curl -u admin:admin -F:name=kitty -Fpwd=kitty -FpwdConfirm=kitty http://localhost:8080/system/userManager/user.create.html
# GET http://localhost:8080/system/userManager/user/aaron.json
# create some groups
curl -u admin:admin -F:name=g-group1 http://localhost:8080/system/userManager/group.create.html
# GET http://localhost:8080/system/userManager/group/g-group1.json to check it exists
# put the users in some groups
# this should be changed later on so that the /system/userManager/user/<username> prefix is not needed and <username> can be used alone
curl -u admin:admin -F:member=/system/userManager/user/aaron -F:member=/system/userManager/user/becky http://localhost:8080/system/userManager/group/g-group1.update.html
# GET http://localhost:8080/system/userManager/group/g-group1.json to check if members are in the group (should see two)
# make the users connect with each other
curl -u aaron:aaron -F"types=spouse" -X POST http://localhost:8080/_user/contacts/becky.invite.html
curl -u aaron:aaron -F"types=pet" -X POST http://localhost:8080/_user/contacts/kitty.invite.html
curl -u becky:becky -X POST http://localhost:8080/_user/contacts/aaron.accept.html
# kitty does not connect though
# try to get the status of the current user
curl -u aaron:aaron http://localhost:8080/_user/presence.json
curl -u becky:becky http://localhost:8080/_user/presence.json
# try to change my status
# TODO
# try to ping with my location
# TODO
# try to clear my status
# TODO
