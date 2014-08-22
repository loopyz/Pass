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
* lastActiveAt - Date

Pet:
* name
* type
* owner - User
* currentUser - User
* miles
* passes
* locName
* geoPoint - PFGeoPoint

Photo:
* image - File
* caption
* user - User
* pet - Pet
* first
* locName
* geoPoint - PFGeoPoint

Activity:
* type
* content
* fromUser - User
* toUser - User
* photo - Photo
