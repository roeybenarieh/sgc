# sgc
app for managing remote insulin injection
## Hardware requirements
* iphone - the app is writen in swift.
* mac computer - the only way(*maybe there is another way I am not familiar with) to upload the app to the iphone is threw macos application calles xcode.
* Internet connection - the app uses API to access glucose checks(CGM), this is done according to pydexcom project.(only works with dexcom sensors)
* 'contour plus' glucometer - this glucometer can remotly inject to Medtronic insulin pump. (only work with some Medtronic pumps)
* arduino + optocoupler = these are hardware components that allow as to controll the glucometer just like it was a human operating it.
* bluetooth low energy module = this module connectes to the arduino and allow as to send remote commands to the arduino from the iphone app.


### things to do
1) create better function for evaluating the injection sugestion
2) store all app settings in a database
3) create the settings screen
