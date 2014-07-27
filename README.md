Spire
====

2014 GreyLock Hackathon

Parse Documentation
-------------------
User:
* fbId
* fbName
* fbProfilePic
* username
* description
* hometown
* registered

Pet:
* name
* type
* owner - User
* currentUser - User
* currentUserId (DEPRECATED, do not use)
* miles
* passes
* latitude
* longitude
* locName

Photo:
* image - File
* caption
* user - User
* pet - Pet
* first
* latitude
* longitude
* locName

Activity:
* type
* content
* fromUser - User
* toUser - User
* photo - Photo
